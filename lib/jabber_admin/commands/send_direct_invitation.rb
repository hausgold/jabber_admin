# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Password and Message can also be: none. Users JIDs are separated with :
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#send-direct-invitation-send-a-direct-invitation-to-several-destinations
    class SendDirectInvitation
      # @param [name] The room name
      # @param [service] MUC service
      # @param [password] Password, or none
      # @param [reason] The reason text, or none
      # @param [users] Users JIDs
      def self.call(name:, service:, password:, reason:, users:)
        joined_users = users.join(':')

        JabberAdmin::ApiCall.perform(
          'send_direct_invitation',
          name: name, service: service, password: password, reason: reason,
          users: joined_users
        )
      end
    end
  end
end
