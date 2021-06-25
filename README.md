![jabber_admin](doc/assets/project.svg)

[![Continuous Integration](https://github.com/hausgold/jabber_admin/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/hausgold/jabber_admin/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/jabber_admin.svg)](https://badge.fury.io/rb/jabber_admin)
[![Maintainability](https://api.codeclimate.com/v1/badges/dd51c4668e97771baaba/maintainability)](https://codeclimate.com/repos/5cac8bcb6969c376ed007c70/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/dd51c4668e97771baaba/test_coverage)](https://codeclimate.com/repos/5cac8bcb6969c376ed007c70/test_coverage)
[![API docs](https://img.shields.io/badge/docs-API-blue.svg)](https://www.rubydoc.info/gems/jabber_admin)

jabber_admin is a small library to easily communicate with the [ejabberd
admin API](https://docs.ejabberd.im/developer/ejabberd-api/admin-api).

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Predefined commands](#predefined-commands)
  - [Freestyle commands](#freestyle-commands)
- [Development](#development)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jabber_admin'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install jabber_admin
```

## Configuration

You can configure the jabber_admin gem in a global initializer way with the
`JabberAdmin.configure` method which yields the configuration directly.

```ruby
JabberAdmin.configure do |config|
  # The ejabberd REST API endpoint as a full URL.
  # Take care of the path part, because this is individually
  # configured on ejabberd. (See: https://bit.ly/2rBxatJ)
  config.url = 'http://jabber.local/api'
  # Provide here the full user JID in order to authenticate as
  # a administrator.
  config.username = 'admin@jabber.local'
  # The password of the administrator account.
  config.password = 'password'
end
```

In case this is not cool for you, you can get and modify the configuration
directly with the help of the `JabberAdmin.configuration` getter.

```ruby
JabberAdmin.configuration.url = 'http://jabber.local/api'
JabberAdmin.configuration.username = 'admin@jabber.local'
JabberAdmin.configuration.password = 'password'
```

## Usage

### Predefined commands

We support some handy predefined commands out of the box which ease the quick
start usage. These predefined commands comes with a good documentation
(including valid example data) and a nifty interface. When it is possible to
fill up missing data from a full user/room JID we do so. Say while sending a
direct invitation, you just pass the full room JID and we take care of
splitting it up to fulfill the separate room name and the separate MUC service
domain.

All our predefined commands are available directly underneath the `JabberAdmin`
module as methods. Just call them like this:

```ruby
JabberAdmin.restart!
JabberAdmin.register(user: 'peter@example.com', password: '123')
```

Have a close look at the method names. We support bang and non-bang variants.
The bang variants perform in-deep response validation and raise children of
`JabberAdmin::Error` in case of detected issues. These issues can be
unpermitted API requests, or invalid payload values, etc. The predefined
commands also perform response body checks when it is appropriate. (Eg. many
commands respond a single zero as a success indicator)

The non-bang variants will just fire the request and do not perform any checks
on the response. You can implement your own error handling or response analysis
if you like. You could also just fire and forget them. It's up to you.

Here comes a list of all supported predefined commands:

- [ban_account](https://bit.ly/2KW9xVt)
- [create_room](https://bit.ly/2rB8DFR)
- [create_room_with_opts](https://bit.ly/2IBEfVO)
- [muc_register_nick](https://bit.ly/2G9EBNQ)
- [registered_users](https://bit.ly/2KhwT6Z)
- [register](https://bit.ly/2wyhAox)
- [restart](https://bit.ly/2G7YEwd)
- [send_direct_invitation](https://bit.ly/2wuTpr2)
- [send_stanza_c2s](https://bit.ly/2wwUcYr)
- [send_stanza](https://bit.ly/2rzxyK1)
- [set_nickname](https://bit.ly/2rBdyqc)
- [set_presence](https://bit.ly/2rzxyK1)
- [set_room_affiliation](https://bit.ly/2G5MfbW)
- [subscribe_room](https://bit.ly/2Ke7Zoy)
- [unregister](https://bit.ly/2wwYnDE)
- [unsubscribe_room](https://bit.ly/2G5zcrj)

If you want to contribute more, we accept pull requests!

### Freestyle commands

In case you want to send commands easily without delivering new predefined
commands with documentation and some nifty tricks, you can simply call the
ejabberd REST API with your custom commands like this:

```ruby
JabberAdmin.status
JabberAdmin.get_last(user: 'tom', host: 'ejabberd.local')
JabberAdmin.set_presence!(...)
```

The `JabberAdmin` is smart enough to detect that the given command is not a
predefined command and therefore it assembles a new `JabberAdmin::ApiCall`
instance and passes down all arguments. If you look closely you see again that
we support a bang and non-bang variant. The error handling works the same as on
predefined commands.

By default the `JabberAdmin::ApiCall` instance assumes it should perform body
checks on the response which is not clever on data fetching commands, due to
the fact that they do not deliver `0` as body. The body validation can be
turned off with the additional `check_res_body: false` argument.

```ruby
JabberAdmin.get_last! \
  check_res_body: false, user: 'tom', host: 'ejabberd.local'
```

In case you want to make use of the memorize feature of each
`JabberAdmin::ApiCall` instance, just build it up directly.

```ruby
command = JabberAdmin::ApiCall.new('get_last'
                                   user: 'tom',
                                   host: 'ejabberd.local')
# Get the response and memorize it
command.response.object_id # => 21934400
# A second call to the response method will not perform a request again
command.response.object_id # => 21934400
```

## Development

After checking out the repo, run `make install` to install dependencies. Then,
run `make test` to run the tests. You can also run `make shell-irb` for an
interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then
run `make release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hausgold/jabber_admin.
