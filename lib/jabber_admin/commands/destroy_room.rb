# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Destroys a given room (MUC).
    #
    # @see https://bit.ly/31CtqxB
    class DestroyRoom
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      # @param host [String] the jabber host (eg. +localhost+)
      def self.call(callable, room:, host:)
        name, service = room.split('@')
        callable.call('destroy_room', name: name, service: service, host: host)
      end
    end
  end
end
