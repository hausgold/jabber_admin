# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::CreateRoomWithOpts do
  describe '#call' do
    it 'creates an API call' do
      allow(JabberAdmin::ApiCall)
        .to receive(:perform)

      described_class.call(name: 'foo', service: 'test', host: 'example.com',
                          options: { foo: 'bar' })

      expect(JabberAdmin::ApiCall)
        .to have_received(:perform)
        .with('create_room_with_opts',
              hash_including(:name, :service, :host, :options))
    end
  end
end
