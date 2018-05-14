### 0.2.0

* [BC] The configuration has changed
  * `api_host` => `url`, we require now the full base URL of the REST API, this allows custom mod_http_api paths (See: https://bit.ly/2rBxatJ)
  * `admin` => `username`, we want to be use common sense API client jargon here
* We support from now on predefined AND freestyle commands on the `JabberAdmin` module
* We support from now on bang and non-bang command variants (for both predefined and freestyle commands) which allows the client to use builtin error handling or not
* [BC] Previously only bang variants were possible, without response checking, look out for more exceptions when you migrate
* New predefined commands:
  * muc_register_nick
  * send_stanza_c2s
  * set_nickname
  * set_presence
* The documentation was greatly improved
* The testcases were rewritten and tested with VCR against a real ejabberd server (18.01)

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