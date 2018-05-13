# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Register a nick to a user JID in the MUC service of a server.
    #
    # *Note*: On ejabberd <= 18.01 this command always returns a error code,
    # even when the command was successful under the hood. (See:
    # https://bit.ly/2L1CpvE)
    #
    # @see https://bit.ly/2G9EBNQ
    class MucRegisterNick
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param nick [String] the user nickname (eg. +TomTom+)
      def self.call(callable, user:, nick:)
        callable.call('muc_register_nick',
                      nick: nick,
                      jid: user,
                      serverhost: user.split('@').last)
      end
    end
  end
end
