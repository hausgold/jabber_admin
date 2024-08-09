### next

* Added API docs building to continuous integration (#14)

### 1.3.0

* Moved the development dependencies from the gemspec to the Gemfile (#12)
* Dropped support for Ruby <2.7 (#13)

### 1.2.0

* Added support for Gem release automation

### 1.1.0

* Bundler >= 2.3 is from now on required as minimal version (#11)
* Dropped support for Ruby < 2.5 (#11)
* Dropped support for Rails < 5.2 (#11)
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version (#11)

### 1.0.5

* Added support for the predefined command `get_room_affiliations` (#10)
* Added the top-level helper `JabberAdmin.room_exist?` to determine whether
  a room exists or not (#10)

### 1.0.4

* Added support for the predefined command `destroy_room`

### 1.0.3

* Migrated to Github Actions
* Migrated to our own coverage reporting
* Added the code statistics to the test process

### 1.0.2

* Corrected the GNU Make release target
* Corrected the empty arguments check

### 1.0.1

* Gracefully handle a missing vCard when a vCard field is queried (#7)

### 1.0.0

* All `JabberAdmin` errors `[UnknownCommandError, CommandError, RequestError]`
  now ship the response object correctly (was always set to `nil` previously)
  (#6)
* Improved the default exceptions messages with the response body (#6)
* Added support for setting/fetching vCard details (`JabberAdmin.set_vcard`,
  `JabberAdmin.get_vcard`) (#6)
* Dropped support for Ruby <2.5 (#6)
* Added some versioning helpers (eg. `JabberAdmin.version`)

### 0.2.0

* [BC] The configuration has changed
  * `api_host` => `url`, we require now the full base URL of the REST API, this
    allows custom mod_http_api paths (See: https://bit.ly/2rBxatJ)
  * `admin` => `username`, we want to be use common sense API client jargon
    here
* We support from now on predefined AND freestyle commands on the `JabberAdmin`
  module
* We support from now on bang and non-bang command variants (for both
  predefined and freestyle commands) which allows the client to use builtin
  error handling or not
* [BC] Previously only bang variants were possible, without response checking,
  look out for more exceptions when you migrate
* New predefined commands:
  * muc_register_nick
  * send_stanza_c2s
  * set_nickname
  * set_presence
* The documentation was greatly improved
* The testcases were rewritten and tested with VCR against a real ejabberd
  server (18.01)

### 0.1.4

* Added support for predefined commands
  * ban_account
  * create_room
  * create_room_with_opts
  * register
  * registered_users
  * restart
  * send_direct_invitation
  * send_stanza
  * set_room_affiliation
  * subscribe_room
  * unregister
  * unsubscribe_room
