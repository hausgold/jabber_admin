# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Send a stanza; provide From JID and valid To JID.
    #
    # @see https://bit.ly/2rzxyK1
    class SetPresence
      # @param callable [Proc, #call] the callable to call
      # @param user [String] user JID w/ resource (eg. +tom@localhost/bot+)
      # @param type [String] the presence type
      #   (eg. +available+, +error+, +probe+)
      # @param show [String] the showed presence
      #   (eg. +away+, +chat+, +dnd+, +xa+)
      # @param status [String] the user status (eg. +I'm online+)
      # @param priority [String] presence priority (eg. +7+)
      #
      # rubocop:disable Metrics/ParameterLists -- because of the mapping
      # rubocop:disable Metrics/MethodLength -- because of the mapping
      def self.call(callable, user:, type: 'available', show: 'chat',
                    status: '', priority: '7')
        uid, host = user.split('@')
        host, resource = host.split('/')
        resource ||= 'bot'
        callable.call('set_presence',
                      user: uid,
                      host: host,
                      resource: resource,
                      type: type,
                      show: show,
                      status: status,
                      priority: priority)
      end
      # rubocop:enable Metrics/ParameterLists, Metrics/MethodLength
    end
  end
end
