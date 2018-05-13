# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Send a message (stanza) as if sent from a c2s session.
    #
    # @see https://bit.ly/2wwUcYr
    class SendStanzaC2s
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID w/ resource (eg. +tom@localhost/bot+)
      # @param stanza [String] the XML stanz to send
      #   (eg. <tt><message to='user1@localhost'>
      #   <ext attr='value'/></message></tt>)
      def self.call(callable, user:, stanza:)
        uid, host = user.split('@')
        host, resource = host.split('/')
        resource ||= 'bot'
        callable.call('send_stanza_c2s',
                      user: uid,
                      host: host,
                      resource: resource,
                      stanza: stanza)
      end
    end
  end
end
