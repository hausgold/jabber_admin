# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Subscribe to a MUC conference
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#subscribe-room-subscribe-to-a-muc-conference
    class SubscribeRoom
      # @param [user] Full JID, including some resource
      # @param [nick] A user's nick
      # @param [room] The room to subscribe
      # @param [nodes] nodes
      def self.call(user:, nick:, room:, nodes:)
        JabberAdmin::ApiCall.perform(
          'subscribe_room',
          user: user, nick: nick, room: room, nodes: nodes
        )
      end
    end
  end
end
