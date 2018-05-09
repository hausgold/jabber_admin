![jabber_admin](doc/assets/project.png)

[![Build Status](https://travis-ci.org/hausgold/jabber_admin.svg?branch=master)](https://travis-ci.org/hausgold/jabber_admin)
[![Gem Version](https://badge.fury.io/rb/jabber_admin.svg)](https://badge.fury.io/rb/jabber_admin)
[![Maintainability](https://api.codeclimate.com/v1/badges/0b3c444d8db8acaaba97/maintainability)](https://codeclimate.com/github/hausgold/jabber_admin/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0b3c444d8db8acaaba97/test_coverage)](https://codeclimate.com/github/hausgold/jabber_admin/test_coverage)
[![API docs](https://img.shields.io/badge/docs-API-blue.svg)](https://www.rubydoc.info/gems/jabber_admin)

jabber_admin is a small library to easily communicate with the [ejabberd
admin API](https://docs.ejabberd.im/developer/ejabberd-api/admin-api).

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jabber_admin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jabber_admin

## Configuration

```ruby
JabberAdmin.configure do |config|
  config.api_host = 'http://jabber.local'
  config.admin = 'admin@jabber.local'
  config.password = 'password'
end
```

## Usage

```ruby
JabberAdmin.restart!
JabberAdmin.create_room!(name: 'room1', host: '...')
```

Currently these basic commands are supported:

- ban_account
- create_room
- create_room_with_opts
- register
- registered_users
- restart
- send_direct_invitation
- send_stanza
- set_room_affiliation
- subscribe_room
- unregister
- unsubscribe_room

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hausgold/jabber_admin.
