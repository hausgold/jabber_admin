# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Change an affiliation in a MUC room
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#set-room-affiliation-change-an-affiliation-in-a-muc-room
    class SetRoomAffiliation
      # @param [name] Room name
      # @param [service] MUC service
      # @param [jid] User JID
      # @param [affiliation] Affiliation to set
      def self.call(name:, service:, jid:, affiliation:)
        JabberAdmin::ApiCall.perform(
          'set_room_affiliation',
          name: name, service: service, jid: jid, affiliation: affiliation
        )
      end
    end
  end
end
