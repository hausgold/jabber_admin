# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::BanAccount do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(user: 'foo', host: 'example.com', reason: 'ban')

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('ban_account', hash_including(:user, :host, :reason))
    end
  end
end
