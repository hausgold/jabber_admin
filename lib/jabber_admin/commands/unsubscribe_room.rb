# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Subscribe to a MUC conference, via the mucsub feature.
    #
    # @see https://bit.ly/2G5zcrj
    class UnsubscribeRoom
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID w/ resource (eg. +tom@localhost/dummy+)
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      def self.call(callable, user:, room:)
        callable.call('unsubscribe_room', user: user, room: room)
      end
    end
  end
end
