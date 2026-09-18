# Upgrading from jabber_admin 2.x to 3.0

This guide covers all breaking changes and required migration steps when
upgrading from jabber_admin 2.10.x to 3.0.

## Table of Contents

- [Dependency Changes](#dependency-changes)
- [Configuration Changes](#configuration-changes)
  - [Request Timeout](#request-timeout)
- [Response Changes](#response-changes)
  - [Response Class](#response-class)
  - [Response Body](#response-body)
  - [Response Headers](#response-headers)
  - [Request Content-Type](#request-content-type)
- [Error Handling Changes](#error-handling-changes)
  - [Command Errors](#command-errors)
  - [Connection Failures and Timeouts](#connection-failures-and-timeouts)
- [Testing Changes](#testing-changes)
  - [Response Doubles](#response-doubles)
  - [Request Stubs](#request-stubs)
  - [VCR Cassettes](#vcr-cassettes)
  - [WebMock Version](#webmock-version)
- [Behavior Differences at a Glance](#behavior-differences-at-a-glance)

---

## Dependency Changes

The HTTP client library changed from `rest-client` to `http` (http.rb).

Dependency    | 2.x        | 3.0        | Upgrading Guide
--------------|------------|------------|----------------
`rest-client` | `~> 2.1`   | _removed_  | -
`http`        | _not used_ | `~> 6.0`   | [Changelog](https://github.com/httprb/http/blob/main/CHANGELOG.md)

**Removed transitive dependencies:**

- `http-accept`, `mime-types`, `mime-types-data`, `netrc` — only rest-client
  needed them

**New transitive dependencies:**

- `llhttp-ffi` — the HTTP parser of http.rb, a native extension loaded via
  `ffi` (make sure your build environment supports it, `ffi` was already
  part of the tree)
- `http-form_data`, `base64` — pulled in by http.rb

The `http-cookie` gem stays in the tree, both clients use it.

If your application used rest-client itself and relied on jabber_admin to
pull it in, add it to your own Gemfile now:

```ruby
gem 'rest-client', '~> 2.1'
```

## Configuration Changes

### Request Timeout

jabber_admin 3.0 adds the optional `config.timeout` option. It defaults to
60 seconds, which matches the implicit Net::HTTP defaults (60 seconds to
connect, 60 seconds to read) of jabber_admin 2.x, so nothing changes unless
you set it.

```ruby
JabberAdmin.configure do |config|
  config.url = 'http://jabber.local/api'
  config.username = 'admin@jabber.local'
  config.password = 'password'

  # A single number caps the whole request (connect, write and read
  # together) in seconds. This is the default with 60 seconds.
  config.timeout = 60

  # A hash sets per-operation limits in seconds instead. The keys are
  # passed to http.rb as they are, unknown keys raise an ArgumentError on
  # the first request.
  config.timeout = { connect: 5, read: 30, write: 10 }

  # Or disable the client timeout entirely.
  config.timeout = nil
end
```

See the [http.rb timeout
documentation](https://github.com/httprb/http/wiki/Timeouts) for the
details of the hash form.

## Response Changes

### Response Class

Every command, `JabberAdmin::ApiCall#response`, `#perform` and `#perform!`
now return an `HTTP::Response` instead of a `RestClient::Response`. The
status code is still an Integer:

```ruby
response = JabberAdmin.get_last(check_res_body: false,
                                user: 'tom', host: 'ejabberd.local')
response.code # => 200
```

### Response Body

**This is the change most likely to affect you.** `response.body` is no
longer a String but an `HTTP::Response::Body` object. Use
`response.body.to_s` (or the shortcut `response.to_s`) wherever you need
the String:

```diff
- JSON.parse(response.body)
+ JSON.parse(response.body.to_s)

- response.body == '0'
+ response.body.to_s == '0'

- response.body.include?('error_no_vcard_found')
+ response.body.to_s.include?('error_no_vcard_found')

- /room does not exist/.match?(response.body)
+ /room does not exist/.match?(response.body.to_s)
```

Beware of `include?` in particular: the body object is enumerable, so
`response.body.include?(...)` does not raise a `NoMethodError` but tries
to stream the already consumed body and fails with an
`HTTP::StateError`.

jabber_admin reads the body eagerly while performing the request, so the
memoized response is complete, the connection is closed, and `to_s`
returns the cached String as often as you call it.

### Response Headers

rest-client exposed the headers as a Hash with symbolized, underscored
keys. http.rb uses the canonical header names:

```diff
- response.headers[:content_type]
+ response.headers['Content-Type']
```

### Request Content-Type

Requests now carry a `Content-Type: application/json; charset=utf-8`
header. jabber_admin 2.x sent the JSON payload without any content type.
The payload itself is unchanged.

## Error Handling Changes

### Command Errors

The error classes and their messages are unchanged. The bang variants still
raise `JabberAdmin::RequestError`, `JabberAdmin::CommandError` and
`JabberAdmin::UnknownCommandError`, all inheriting from
`JabberAdmin::Error`, and the message still carries the response body
(`"Response code was not 200 => {...}"`). Code which matches on
`error.message` keeps working:

```ruby
begin
  JabberAdmin.register!(user: 'tom@jabber.local', password: 'secret')
rescue JabberAdmin::RequestError => e
  raise e unless /already registered/.match?(e.message)
end
```

Only `error.response` changed its class to `HTTP::Response`, so the
[Response Body](#response-body) rules apply when you read it:

```diff
- e.response.body.include?('already registered')
+ e.response.body.to_s.include?('already registered')
```

### Connection Failures and Timeouts

jabber_admin 2.x rescued every `RestClient::Exception`, including timeouts
and broken connections, and memoized their (missing) response. The failure
surfaced later as a `NoMethodError` on `nil`.

jabber_admin 3.0 lets these failures raise directly from `#response`,
`#perform` and `#perform!` as http.rb errors, all inheriting from
`HTTP::Error`:

- `HTTP::ConnectionError` — DNS failures, refused connections, broken
  sockets
- `HTTP::TimeoutError` — the configured timeout elapsed (see [Request
  Timeout](#request-timeout))

Rescue them where you want to handle unreachable ejabberd instances:

```diff
  begin
    JabberAdmin.restart!
- rescue JabberAdmin::Error, NoMethodError => e
+ rescue JabberAdmin::Error, HTTP::Error => e
    # ...
  end
```

Responses with a 4xx or 5xx status are still delivered as regular responses
and turned into `JabberAdmin::Error` subclasses by the bang variants, as
before.

## Testing Changes

### Response Doubles

Replace `RestClient::Response` doubles with real `HTTP::Response` objects.
They are cheap to build and behave like the responses jabber_admin
delivers:

```diff
- let(:response) do
-   instance_double(RestClient::Response, code: 200, body: '0')
- end
+ let(:response) do
+   HTTP::Response.new(status: 200, version: '1.1', body: '0')
+ end
```

### Request Stubs

Stubs of `RestClient::Request.execute` no longer intercept anything.
Stub the wire format with WebMock instead, which also lets you assert on
the request:

```diff
- allow(RestClient::Request).to receive(:execute).and_return(response)
+ stub_request(:post, 'http://jabber.local/api/restart').to_return(body: '0')

- expect(RestClient::Request).to \
-   receive(:execute).with(a_hash_including(user: 'admin@jabber.local'))
+ stub = stub_request(:post, 'http://jabber.local/api/restart')
+   .with(basic_auth: %w[admin@jabber.local password])
+ # ... perform the command ...
+ expect(stub).to have_been_requested
```

Stubbing at the jabber_admin level (`allow(JabberAdmin).to
receive(:restart!)`) keeps working unchanged.

### VCR Cassettes

Cassettes recorded with jabber_admin 2.x replay without re-recording, as
long as your VCR configuration uses the default request matchers (method
and URI). The JSON request body is byte-identical to 2.x. If you match on
headers, note the new `Content-Type` request header and the changed
`User-Agent`.

### WebMock Version

http.rb 6 requires WebMock 3.26 or newer, older adapters build the
responses with a positional Hash and fail with an `ArgumentError` on
`HTTP::Response.new`. Update your lock:

```shell
$ bundle update webmock
```

## Behavior Differences at a Glance

Aspect              | 2.x (rest-client)                 | 3.0 (http.rb)
--------------------|-----------------------------------|----------------------------------------
Response class      | `RestClient::Response`            | `HTTP::Response`
`response.code`     | Integer                           | Integer
`response.body`     | String                            | `HTTP::Response::Body`, use `.to_s`
`response.headers`  | `{ content_type: ... }`           | `{ 'Content-Type' => ... }`
4xx/5xx responses   | `JabberAdmin::Error` on bang       | unchanged
Connection failures | swallowed, later `NoMethodError`  | `HTTP::ConnectionError`
Timeouts            | implicit 60s connect / 60s read   | `config.timeout`, 60s global by default
Request body        | `payload.to_json`                 | unchanged
Request headers     | no `Content-Type`                 | `Content-Type: application/json; charset=utf-8`
