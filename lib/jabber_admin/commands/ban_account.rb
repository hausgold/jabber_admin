# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Ban an account by kicking sessions and set random password.
    #
    # @see https://bit.ly/2KW9xVt
    class BanAccount
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param reason [String] the banning reason (eg. +Spamming other users+)
      def self.call(callable, user:, reason:)
        uid, host = user.split('@')
        callable.call('ban_account', user: uid, host: host, reason: reason)
      end
    end
  end
end
