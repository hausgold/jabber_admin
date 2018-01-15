# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Restart ejabberd gracefully
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#restart-restart-ejabberd-gracefully
    class Restart
      def self.call
        JabberAdmin::ApiCall.perform 'restart'
      end
    end
  end
end
