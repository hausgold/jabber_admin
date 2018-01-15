# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Subscribe to a MUC conference
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#unsubscribe-room-unsubscribe-from-a-muc-conference
    class UnsubscribeRoom
      # @param [user] Full JID, including some resource
      # @param [room] The room to subscribe
      def self.call(user:, room:)
        JabberAdmin::ApiCall.perform 'unsubscribe_room', user: user, room: room
      end
    end
  end
end
