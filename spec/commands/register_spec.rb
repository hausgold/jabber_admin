# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::Register do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(user: 'foo', host: 'example.com', password: 'aaa')

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('register', hash_including(:user, :host, :password))
    end
  end
end
