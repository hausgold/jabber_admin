# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Unregister a user
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#unregister-unregister-a-user
    class Unregister
      # @param [user] The username
      # @param [host] Local vhost served by ejabberd
      def self.call(user:, host:)
        JabberAdmin::ApiCall.perform 'unregister', user: user, host: host
      end
    end
  end
end
