# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin do
  describe '.respond_to?' do
    it 'responds to known command' do
      expect(described_class.respond_to?(:register!)).to eq(true)
    end

    it 'does not respond to unknown command' do
      expect(described_class.respond_to?(:foobar!)).to eq(false)
    end
  end

  describe '.method_missing' do
    before do
      allow(JabberAdmin::Commands::Restart).to receive(:call)
    end

    context 'when command is valid' do
      it 'calls the right command' do
        described_class.restart!
        expect(JabberAdmin::Commands::Restart).to have_received(:call)
      end
    end
  end

  context 'when command is not valid' do
    it 'throws an error' do
      expect { described_class.foobar! }.to raise_error(NameError)
    end
  end

  describe '.configure' do
    before do
      JabberAdmin.configure do |config|
        config.api_host = "https://jabber.example.com"
      end
    end

    it 'configures the Gem' do
      expect(JabberAdmin.configuration.api_host)
        .to eq("https://jabber.example.com")
    end
  end

  describe '.registered_users!' do
    before do
      allow(JabberAdmin::Commands::RegisteredUsers)
        .to receive(:call)

      described_class.registered_users!(host: 'example.com')
    end

    it 'executes the right command' do
      expect(JabberAdmin::Commands::RegisteredUsers)
        .to have_received(:call)
        .with(host: 'example.com')
    end
  end
end
