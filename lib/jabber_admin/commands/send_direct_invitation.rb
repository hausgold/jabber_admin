# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Send a direct invitation to several destinations.
    #
    # @see https://bit.ly/2wuTpr2
    class SendDirectInvitation
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param room [String] room JID (eg. +room1@conference.localhost+)
      # @param users [Array<String>] user JIDs wo/ resource
      #   (eg. +tom@localhost+)
      # @param password [String] a optional room password
      # @param reason [String] the reason for the invitation
      def self.call(callable, room:, users:, password: '', reason: '')
        name, service = room.split('@')
        callable.call('send_direct_invitation',
                      name: name,
                      service: service,
                      password: password,
                      reason: reason,
                      users: users.join(':'))
      end
    end
  end
end
