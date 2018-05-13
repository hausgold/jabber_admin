# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Send a stanza; provide From JID and valid To JID.
    #
    # @see https://bit.ly/2rzxyK1
    class SendStanza
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param from [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param to [String] user/room JID wo/ resource (eg. +bob@localhost+)
      # @param stanza [String] the XML stanz to send
      #   (eg. <tt><message><ext attr='value'/></message></tt>)
      def self.call(callable, from:, to:, stanza:)
        callable.call('send_stanza', from: from, to: to, stanza: stanza)
      end
    end
  end
end
