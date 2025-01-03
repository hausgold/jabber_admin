# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin do
  describe '.configuration' do
    it 'return a new instance of JabberAdmin::Configuration' do
      expect(described_class.configuration).to be_a(JabberAdmin::Configuration)
    end

    it 'memorizes the configuration instance' do
      conf = described_class.configuration
      expect(described_class.configuration).to be(conf)
    end
  end

  describe '.configure' do
    it 'yields the configuration object' do
      conf = described_class.configuration
      expect { |block| described_class.configure(&block) }.to \
        yield_with_args(conf)
    end

    it 'saves the new configuration values' do
      described_class.configure do |config|
        config.url = 'https://jabber.local/api'
      end
      expect(described_class.configuration.url).to \
        eq('https://jabber.local/api')
    end
  end

  describe '.method_missing' do
    before do
      allow(JabberAdmin::ApiCall).to receive(:perform)
      allow(JabberAdmin::ApiCall).to receive(:perform!)
    end

    context 'with predefined commands' do
      context 'with bang' do
        it 'passes the arguments down to the API call' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform!).once.with('unregister', check_res_body: false,
                                                       user: 'tom',
                                                       host: 'jabber.local')
          described_class.unregister!(user: 'tom@jabber.local')
        end

        it 'passes no arguments when none are given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform!).once.with('restart')
          described_class.restart!
        end

        it 'passes no block when one is given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform!).once.with('restart')
          described_class.restart! { true }
        end
      end

      context 'without bang' do
        it 'passes the arguments down to the API call' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform).once.with('unregister', check_res_body: false,
                                                      user: 'tom',
                                                      host: 'jabber.local')
          described_class.unregister(user: 'tom@jabber.local')
        end

        it 'passes no arguments when none are given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform).once.with('restart')
          described_class.restart
        end

        it 'passes no block when one is given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform).once.with('restart')
          described_class.restart { true }
        end
      end
    end

    context 'without predefined commands' do
      context 'with bang' do
        it 'passes the arguments down to the API call' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform!).once.with('unknown', user: 'Tom')
          described_class.unknown!(user: 'Tom')
        end

        it 'passes no arguments when none are given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform!).once.with('unknown')
          described_class.unknown!
        end

        it 'passes no block when one is given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform!).once.with('unknown')
          described_class.unknown! { true }
        end
      end

      context 'without bang' do
        it 'passes the arguments down to the API call' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform).once.with('unknown', user: 'Tom')
          described_class.unknown(user: 'Tom')
        end

        it 'passes no arguments when none are given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform).once.with('unknown')
          described_class.unknown
        end

        it 'passes no block when one is given' do
          expect(JabberAdmin::ApiCall).to \
            receive(:perform).once.with('unknown')
          described_class.unknown { true }
        end
      end
    end
  end

  describe '.predefined_command' do
    it 'raises a NameError in case the given command is not known' do
      expect { described_class.predefined_command('unknown') }.to \
        raise_error(NameError)
    end

    it 'returns the class constant when the given command is known' do
      expect(described_class.predefined_command('restart')).to \
        be(JabberAdmin::Commands::Restart)
    end

    it 'can deal with bang-versions' do
      expect(described_class.predefined_command('restart!')).to \
        be(JabberAdmin::Commands::Restart)
    end
  end

  describe '.predefined_callable' do
    before do
      allow(JabberAdmin::ApiCall).to receive(:perform)
      allow(JabberAdmin::ApiCall).to receive(:perform!)
    end

    it 'builds a working wrapper for a bang version' do
      expect(JabberAdmin::ApiCall).to receive(:perform!).once
      described_class.predefined_callable('unknown!').call
    end

    it 'builds a working wrapper for a non-bang version' do
      expect(JabberAdmin::ApiCall).to receive(:perform).once
      described_class.predefined_callable('unknown').call
    end

    it 'passes down arguments' do
      args = { user: 'Tom', room: 'Basement' }
      expect(JabberAdmin::ApiCall).to receive(:perform).once.with(**args)
      described_class.predefined_callable('unknown').call(**args)
    end
  end

  describe '.room_exist?', :vcr do
    let(:room) { 'room1@conference.ejabberd.local' }
    let(:host) { room.split('@').last }

    context 'with an existing room' do
      before { described_class.create_room(room: room, host: host) }

      it 'returns true' do
        expect(described_class.room_exist?(room)).to be(true)
      end
    end

    context 'without an existing room' do
      let(:room) { 'no-room@conference.ejabberd.local' }

      it 'returns false' do
        expect(described_class.room_exist?(room)).to be(false)
      end
    end
  end

  describe '.respond_to?' do
    context 'with predefined commands' do
      it 'responds to commands with bang' do
        expect(described_class.respond_to?(:register!)).to be(true)
      end

      it 'responds to commands without bang' do
        expect(described_class.respond_to?(:register)).to be(true)
      end
    end

    context 'without predefined commands' do
      it 'responds to commands with bang' do
        expect(described_class.respond_to?(:unknown!)).to be(true)
      end

      it 'responds to commands without bang' do
        expect(described_class.respond_to?(:unknown)).to be(true)
      end
    end
  end
end
