# frozen_string_literal: true

module JabberAdmin
  module Commands
    # List all registered users on the ejabberd vhost.
    #
    # @see https://bit.ly/2KhwT6Z
    class RegisteredUsers
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param host [String] the jabber vhost (eg. +localhost+)
      def self.call(callable, host:)
        callable.call('registered_users', check_res_body: false, host: host)
      end
    end
  end
end
