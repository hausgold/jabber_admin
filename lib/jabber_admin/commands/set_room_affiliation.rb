# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Change a user affiliation in a MUC room. (eg. allow him to enter a
    # members-only room)
    #
    # @see https://bit.ly/2G5MfbW
    class SetRoomAffiliation
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      # @param affiliation [String] the MUC/user affiliation (eg. +member+)
      def self.call(callable, user:, room:, affiliation: 'member')
        name, service = room.split('@')
        callable.call('set_room_affiliation',
                      name: name,
                      service: service,
                      jid: user,
                      affiliation: affiliation)
      end
    end
  end
end
