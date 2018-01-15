# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Create a MUC room name@service in host
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#create-room-create-a-muc-room-name-service-in-host
    class CreateRoom
      # @param [name] The room name
      # @param [service] MUC service
      # @param [host] Server host
      def self.call(name:, service:, host:)
        JabberAdmin::ApiCall.perform(
          'create_room', name: name, service: service, host: host
        )
      end
    end
  end
end
