# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Unregister (delete) a user from the XMPP service.
    #
    # @see https://bit.ly/2wwYnDE
    class Unregister
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      def self.call(callable, user:)
        uid, host = user.split('@')
        callable.call('unregister',
                      check_res_body: false,
                      user: uid,
                      host: host)
      end
    end
  end
end
