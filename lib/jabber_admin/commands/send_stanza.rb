# frozen_string_literal: true

module JabberAdmin
  module Commands
    ##
    # Send a stanza; provide From JID and valid To JID
    # https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#send-stanza-send-a-stanza-provide-from-jid-and-valid-to-jid
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
