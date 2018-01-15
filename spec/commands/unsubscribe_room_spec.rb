# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::UnsubscribeRoom do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(user: 'foo', room: 'test')

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('unsubscribe_room', hash_including(:user, :room))
    end
  end
end
