# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Subscribe to a MUC conference, via the mucsub feature.
    #
    # @see https://bit.ly/2Ke7Zoy
    class SubscribeRoom
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID w/ resource (eg. +tom@localhost/dummy+)
      # @param nick [String] the user nickname (eg. +TomTom+)
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      # @param nodes [Array<String>] nodes comma separated
      #   (eg. +urn:xmpp:mucsub:nodes:messages+,
      #   +urn:xmpp:mucsub:nodes:affiliations+)
      def self.call(callable, user:, nick:, room:, nodes: [])
        callable.call('subscribe_room',
                      check_res_body: false,
                      user: user,
                      nick: nick,
                      room: room,
                      nodes: nodes.join(','))
      end
    end
  end
end
