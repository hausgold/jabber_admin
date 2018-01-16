# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Create a MUC room name@service in host
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#create-room-with-opts-create-a-muc-room-name-service-in-host-with-given-options
    class CreateRoomWithOpts
      # @param [name] The room name
      # @param [service] MUC service
      # @param [host] Server host
      # @param [options] [{ Name::String, Value::String }] List of options
      def self.call(name:, service:, host:, options:)
        JabberAdmin::ApiCall.perform(
          'create_room_with_opts', name: name,
                                   service: service,
                                   host: host,
                                   options: options
        )
      end
    end
  end
end
