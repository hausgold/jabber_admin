# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::RegisteredUsers do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(host: 'example.com')

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('registered_users', host: 'example.com')
    end
  end
end
