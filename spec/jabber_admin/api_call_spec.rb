# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::ApiCall do
  let(:instance) { described_class.new('restart') }
  let(:fake_response) do
    instance_double(RestClient::Response, code: 200, body: '0')
  end

  describe '#new' do
    let(:instance) { described_class.new('command', test: true, a: 'b') }

    it 'saves the given command' do
      expect(instance.command).to eql('command')
    end

    it 'saves the given payload' do
      expect(instance.payload).to eql(test: true, a: 'b')
    end
  end

  describe '#url' do
    it 'produces the correct URL with trailling slash and whitespaces' do
      allow(JabberAdmin.configuration).to \
        receive(:url).and_return("\n http://with.trailling.slash/api/  \n")
      expect(instance.url).to \
        eql('http://with.trailling.slash/api/restart')
    end

    it 'produces the correct URL with trailling slash' do
      allow(JabberAdmin.configuration).to \
        receive(:url).and_return('http://with.trailling.slash/api/')
      expect(instance.url).to \
        eql('http://with.trailling.slash/api/restart')
    end

    it 'produces the correct URL without trailling slash' do
      allow(JabberAdmin.configuration).to \
        receive(:url).and_return('http://without.trailling.slash/api')
      expect(instance.url).to \
        eql('http://without.trailling.slash/api/restart')
    end
  end

  describe '#response', :vcr do
    it 'returns a RestClient::Response instance' do
      expect(instance.response).to be_a(RestClient::Response)
    end

    it 'memorizes the response' do
      instance = described_class.new('status')
      response = instance.response
      expect(instance.response).to be(response)
    end

    context 'with mock configuration' do
      before do
        allow(JabberAdmin.configuration).to \
          receive_messages(username: 'username',
                           password: 'password',
                           url: 'http://test/api/')
      end

      it 'sends the payload as a JSON string' do
        hash = a_hash_including(payload: '{"test":{"test":true}}')
        expect(RestClient::Request).to receive(:execute).once.with(hash)
        described_class.new('status', test: { test: true }).perform
      end

      it 'sends the configured username' do
        hash = a_hash_including(user: 'username')
        expect(RestClient::Request).to receive(:execute).once.with(hash)
        instance.perform
      end

      it 'sends the configured password' do
        hash = a_hash_including(password: 'password')
        expect(RestClient::Request).to receive(:execute).once.with(hash)
        instance.perform
      end

      it 'asks the url method for the correct url' do
        allow(RestClient::Request).to receive(:execute)
        expect(instance).to receive(:url).once
        instance.perform
      end

      it 'sends the correct URL' do
        hash = a_hash_including(url: 'http://test/api/restart')
        expect(RestClient::Request).to receive(:execute).once.with(hash)
        instance.perform
      end

      it 'sends a POST request' do
        hash = a_hash_including(method: :post)
        expect(RestClient::Request).to receive(:execute).once.with(hash)
        instance.perform
      end
    end
  end

  describe '#check_response', :vcr do
    let(:destroy_room) do
      described_class.new(
        'destroy_room', name: 'test', service: 'conference.ejabberd.local'
      )
    end

    it 'does not raise on a good response' do
      expect { instance.check_response }.not_to raise_error
    end

    it 'raises on failed requests' do
      allow(JabberAdmin.configuration).to receive(:username).and_return('fail')
      expect { described_class.new('restart').check_response }.to \
        raise_error(JabberAdmin::RequestError)
    end

    it 'raises on unknown commands' do
      expect { described_class.new('unknown').check_response }.to \
        raise_error(JabberAdmin::UnknownCommandError)
    end

    it 'raises on failed commands (validation issues)' do
      expect { described_class.new('create_room').check_response }.to \
        raise_error(JabberAdmin::CommandError)
    end

    it 'raises on failed commands (internal issues)' do
      expect { destroy_room.check_response }.to \
        raise_error(JabberAdmin::CommandError)
    end

    it 'raises not on failed commands when body check is disabled' do
      destroy_room = described_class.new(
        'destroy_room', check_res_body: false, name: 'test',
                        service: 'conference.ejabberd.local'
      )
      expect { destroy_room.check_response }.not_to raise_error
    end
  end

  describe '#perform!' do
    it 'calls the check_response method' do
      allow(RestClient::Request).to receive(:execute).and_return(fake_response)
      expect(instance).to receive(:check_response).once
      instance.perform!
    end

    it 'calls the response method' do
      expect(instance).to \
        receive(:response).and_return(fake_response).at_least(:twice)
      instance.perform!
    end
  end

  describe '#perform' do
    it 'does not call the check_response method' do
      allow(RestClient::Request).to receive(:execute).and_return(fake_response)
      expect(instance).not_to receive(:check_response)
      instance.perform
    end

    it 'calls the response method' do
      expect(instance).to \
        receive(:response).and_return(fake_response).once
      instance.perform
    end
  end

  describe '.perform!' do
    let(:instance) { described_class.new('another_command', test: true) }

    before do
      allow(RestClient::Request).to receive(:execute).and_return(fake_response)
    end

    it 'passes all arguments to a fresh instance' do
      expect(described_class).to receive(:new) \
        .with('another_command', test: true).once.and_return(instance)
      described_class.perform!('another_command', test: true)
    end

    it 'calls the perform! method on the new instance' do
      allow(described_class).to receive(:new).and_return(instance)
      expect(instance).to receive(:perform!).once
      described_class.perform!('another_command', test: true)
    end
  end

  describe '.perform' do
    before do
      allow(RestClient::Request).to receive(:execute).and_return(fake_response)
    end

    it 'passes all arguments to a fresh instance' do
      expect(described_class).to receive(:new) \
        .with('another_command', test: true).once.and_return(instance)
      described_class.perform('another_command', test: true)
    end

    it 'calls the perform method on the new instance' do
      allow(described_class).to receive(:new).and_return(instance)
      expect(instance).to receive(:perform).once
      described_class.perform('another_command', test: true)
    end
  end
end
