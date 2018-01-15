# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Register a user
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#register-register-a-user
    class Register
      # @param [user] The username
      # @param [host] Local vhost served by ejabberd
      # @param [password] The password
      def self.call(user:, host:, password:)
        JabberAdmin::ApiCall.perform(
          'register',
          user: user, host: host, password: password
        )
      end
    end
  end
end
