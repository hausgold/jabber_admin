# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # List all registered users in HOST
    #
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#registered-users-list-all-registered-users-in-host
    class RegisteredUsers
      # @param [host] The Local vhost
      def self.call(host:)
        JabberAdmin::ApiCall.perform 'registered_users', host: host
      end
    end
  end
end
