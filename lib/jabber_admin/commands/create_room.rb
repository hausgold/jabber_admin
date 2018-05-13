# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Create a new room (MUC).
    #
    # @see https://bit.ly/2rB8DFR
    class CreateRoom
      # Pass the correct data to the given callable.
      #
      # *Note:* this command should not be used in the bang-variant, due to raw
      # result string in the response. (the response body is not zero/one like
      # on almost all commands)
      #
      # @param callable [Proc, #call] the callable to call
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      # @param host [String] the jabber host (eg. +localhost+)
      def self.call(callable, room:, host:)
        name, service = room.split('@')
        callable.call('create_room', name: name, service: service, host: host)
      end
    end
  end
end
