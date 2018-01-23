# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SendStanza do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(
        from: 'foo@example.com', to: 'bar@example.com',
        stanza: '<example>Stanza</example>'
      )

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with(
          'send_stanza',
          from: 'foo@example.com',
          to: 'bar@example.com',
          stanza: '<example>Stanza</example>'
        )
    end
  end
end
