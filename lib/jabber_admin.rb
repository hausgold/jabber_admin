# frozen_string_literal: true

require "active_support/inflector"
require "rest-client"
require "json"

require "jabber_admin/initializer"
require "jabber_admin/configuration"
require "jabber_admin/commands"
require "jabber_admin/api_call"
require "jabber_admin/version"

##
# Jabber Admin Library
#
# allows making API calls to the ejabberd RESTful admin backend
# All supported commands are available in /lib/jabber_admin/commands/
#
# Usage:
# All commands can be called via JabberAdmin.[method_name]!
# (Do not forget the bang at the end)
#
# @example:
#   JabberAdmin.register!(user: 'peter', 'host': 'example.com', password: '123')
#   JabberAdmin.unregister!(user: 'peter', 'host': 'example.com')
#   JabberAdmin.restart!
#
module JabberAdmin
  class << self
    attr_writer :configuration
  end

  # @return [JabberAdmin::Configuration] The global JabberAdmin configuration
  def self.configuration
    @configuration ||= JabberAdmin::Configuration.new
  end

  # Class method to set and change the global configuration
  #
  # @example
  #   JabberAdmin.configure do |config|
  #     config.api_host = 'xmpp.example.com'
  #     config.admin = 'admin'
  #     config.password = 'password'
  #   end
  def self.configure
    yield(configuration)
  end

  def self.method_missing(method, *args, &block)
    command = "jabber_admin/commands/#{method[0..-2]}".classify.constantize
    args.empty? ? command.call : command.call(*args)
  rescue NameError
    super
  end

  def self.respond_to_missing?(method, include_private = false)
    "jabber_admin/commands/#{method[0..-2]}".classify.constantize && true
  rescue NameError
    super
  end
end
