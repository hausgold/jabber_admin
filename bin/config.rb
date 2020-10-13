# frozen_string_literal: true

$VERBOSE = nil
require 'bundler/setup'
require 'jabber_admin'

JabberAdmin.configure do |conf|
  conf.username = 'admin@jabber.local'
  conf.password = 'defaultpw'
  conf.url = 'http://jabber.local/api'
end
