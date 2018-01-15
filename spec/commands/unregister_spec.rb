# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::Unregister do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(user: 'foo', host: 'example.com')

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('unregister', hash_including(:user, :host))
    end
  end
end
