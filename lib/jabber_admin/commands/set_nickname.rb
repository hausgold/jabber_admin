# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Set nickname in a user's vCard.
    #
    # @see https://bit.ly/2rBdyqc
    class SetNickname
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param nick [String] the user nickname (eg. +TomTom+)
      def self.call(callable, user:, nick:)
        uid, host = user.split('@')
        callable.call(
          'set_nickname', user: uid, host: host, nickname: nick
        )
      end
    end
  end
end
