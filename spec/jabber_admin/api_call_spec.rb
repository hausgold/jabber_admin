# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::ApiCall do
  let(:instance) { described_class.new('restart') }
  let(:fake_response) do
    HTTP::Response.new(status: 200, version: '1.1', body: '0')
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
    it 'produces the correct URL with trailing slash and whitespaces' do
      allow(JabberAdmin.configuration).to \
        receive(:url).and_return("\n http://with.trailing.slash/api/  \n")
      expect(instance.url).to \
        eql('http://with.trailing.slash/api/restart')
    end

    it 'produces the correct URL with trailing slash' do
      allow(JabberAdmin.configuration).to \
        receive(:url).and_return('http://with.trailing.slash/api/')
      expect(instance.url).to \
        eql('http://with.trailing.slash/api/restart')
    end

    it 'produces the correct URL without trailing slash' do
      allow(JabberAdmin.configuration).to \
        receive(:url).and_return('http://without.trailing.slash/api')
      expect(instance.url).to \
        eql('http://without.trailing.slash/api/restart')
    end
  end

  describe '#client' do
    let(:client) { instance.client }
    let(:timeout) { 60 }

    before do
      allow(JabberAdmin.configuration).to \
        receive_messages(username: 'username',
                         password: 'password',
                         timeout: timeout)
    end

    it 'returns a HTTP session' do
      expect(client).to be_a(HTTP::Session)
    end

    it 'configures the basic authentication' do
      expect(client.default_options.headers['Authorization']).to \
        eql('Basic dXNlcm5hbWU6cGFzc3dvcmQ=')
    end

    context 'with a numeric timeout' do
      it 'configures a global timeout' do
        expect(client.default_options.timeout_class).to \
          be(HTTP::Timeout::Global)
      end

      it 'passes the seconds' do
        expect(client.default_options.timeout_options).to \
          eql(global_timeout: 60)
      end
    end

    context 'with a per-operation timeout' do
      let(:timeout) { { connect: 5, read: 30, write: 10 } }

      it 'configures a per-operation timeout' do
        expect(client.default_options.timeout_class).to \
          be(HTTP::Timeout::PerOperation)
      end

      it 'passes the operation limits' do
        expect(client.default_options.timeout_options).to \
          eql(connect_timeout: 5, read_timeout: 30, write_timeout: 10)
      end
    end

    context 'without a timeout' do
      let(:timeout) { nil }

      it 'configures no timeout' do
        expect(client.default_options.timeout_class).to \
          be(HTTP::Timeout::Null)
      end
    end
  end

  describe '#response', :vcr do
    it 'returns a HTTP::Response instance' do
      expect(instance.response).to be_a(HTTP::Response)
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
        stub = stub_request(:post, 'http://test/api/status')
               .with(body: '{"test":{"test":true}}')
        described_class.new('status', test: { test: true }).perform
        expect(stub).to have_been_requested
      end

      it 'sends the payload as a JSON document' do
        stub = stub_request(:post, 'http://test/api/restart').with(
          headers: { 'Content-Type' => 'application/json; charset=utf-8' }
        )
        instance.perform
        expect(stub).to have_been_requested
      end

      it 'sends the configured credentials as basic authentication' do
        stub = stub_request(:post, 'http://test/api/restart')
               .with(basic_auth: %w[username password])
        instance.perform
        expect(stub).to have_been_requested
      end

      it 'asks the url method for the correct url' do
        stub_request(:post, 'http://test/api/restart')
        expect(instance).to receive(:url).once.and_call_original
        instance.perform
      end

      it 'sends a POST request to the correct URL' do
        stub = stub_request(:post, 'http://test/api/restart')
        instance.perform
        expect(stub).to have_been_requested
      end

      it 'delivers the response body' do
        stub_request(:post, 'http://test/api/restart').to_return(body: '0')
        expect(instance.perform.body.to_s).to eql('0')
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
    before { stub_request(:post, %r{http://jabber/api/}).to_return(body: '0') }

    it 'calls the check_response method' do
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
    before { stub_request(:post, %r{http://jabber/api/}).to_return(body: '0') }

    it 'does not call the check_response method' do
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

    before { stub_request(:post, %r{http://jabber/api/}).to_return(body: '0') }

    it 'passes all arguments to a fresh instance' do
      expect(described_class).to receive(:new)
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
    before { stub_request(:post, %r{http://jabber/api/}).to_return(body: '0') }

    it 'passes all arguments to a fresh instance' do
      expect(described_class).to receive(:new)
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
