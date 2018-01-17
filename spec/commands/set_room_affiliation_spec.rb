# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SetRoomAffiliation do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(
        name: 'room1', service: 'foo', jid: 'jid', affiliation: 'member'
      )

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with(
          'set_room_affiliation',
          hash_including(:name, :service, :jid, :affiliation)
        )
    end
  end
end
