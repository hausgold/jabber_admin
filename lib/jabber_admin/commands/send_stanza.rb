# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Password and Message can also be: none. Users JIDs are separated with :
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#send-direct-invitation-send-a-direct-invitation-to-several-destinations
    class SendStanza
      # @param [from] Sender JID
      # @param [to] Receiver JID
      # @param [stanza] Stanza
      def self.call(from:, to:, stanza:)
        JabberAdmin::ApiCall.perform(
          'send_stanza', to: to, from: from, stanza: stanza
        )
      end
    end
  end
end
