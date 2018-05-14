# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Register a new user on the XMPP service.
    #
    # @see https://bit.ly/2wyhAox
    class Register
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param password [String] the new plain password for the user
      #   (eg. +secret+)
      def self.call(callable, user:, password:)
        uid, host = user.split('@')
        callable.call('register',
                      check_res_body: false,
                      user: uid,
                      host: host,
                      password: password)
      end
    end
  end
end
