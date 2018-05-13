# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Create a new room (MUC) with additional options.
    #
    # @see https://bit.ly/2IBEfVO
    class CreateRoomWithOpts
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      # @param host [String] the jabber host (eg. +localhost+)
      # @param options pass additional +symbol: value+ pairs
      def self.call(callable, room:, host:, **options)
        name, service = room.split('@')
        options = options.map do |key, value|
          Hash['name', key.to_s, 'value', value.to_s]
        end

        callable.call('create_room_with_opts',
                      name: name,
                      service: service,
                      host: host,
                      options: options)
      end
    end
  end
end
