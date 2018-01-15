# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SendDirectInvitation do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(
        name: 'foo', service: 'aaa', password: 'aaa', reason: 'foo',
        users: ['1234@example.com', '4312@example.com']
      )

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with 'send_direct_invitation',
              hash_including(
                name: 'foo',
                service: 'aaa',
                password: 'aaa',
                reason: 'foo',
                users: '1234@example.com:4312@example.com'
              )
    end
  end
end
