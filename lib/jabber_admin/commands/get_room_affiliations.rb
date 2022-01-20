# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Get room affiliations.
    #
    # @see https://bit.ly/3qI9Nyq
    class GetRoomAffiliations
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      def self.call(callable, room:)
        name, service = room.split('@')
        res = callable.call('get_room_affiliations', check_res_body: false,
                                                     name: name,
                                                     service: service)

        res.body ? JSON.parse(res.body) : nil
      end
    end
  end
end
