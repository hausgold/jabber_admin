# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Ban an account: kick sessions and set random password
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#ban-account-ban-an-account-kick-sessions-and-set-random-password
    class BanAccount
      # @param [user] The user
      # @param [host] Server name
      # @param [reason] Reason for banning user
      def self.call(user:, host:, reason:)
        JabberAdmin::ApiCall.perform(
          'ban_account', user: user, host: host, reason: reason
        )
      end
    end
  end
end
