# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::Restart do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform).with('restart')
    end
  end
end
