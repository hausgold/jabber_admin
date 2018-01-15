# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SubscribeRoom do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(user: 'foo', nick: 'foo', room: 'test', nodes: 'aa')

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('subscribe_room', hash_including(:user, :nick, :room, :nodes))
    end
  end
end
