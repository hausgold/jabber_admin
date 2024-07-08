# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SetVcard do
  before { alternative_config! }

  describe 'first level, single field, scalar value' do
    it_behaves_like 'a command',
                    with_name: 'set_vcard',
                    with_input_args: [
                      user: 'admin@jabber.local',
                      fn: 'The Admin'
                    ],
                    with_called_args: [
                      user: 'admin',
                      host: 'jabber.local',
                      name: 'FN',
                      content: 'The Admin'
                    ]
  end

  describe 'second level, single field, scalar value' do
    it_behaves_like 'a command',
                    with_name: 'set_vcard',
                    with_called_name: 'set_vcard2',
                    with_input_args: [
                      user: 'admin@jabber.local',
                      'n.given': 'Aang'
                    ],
                    with_called_args: [
                      user: 'admin',
                      host: 'jabber.local',
                      name: 'N',
                      subname: 'GIVEN',
                      content: 'Aang'
                    ]
  end

  describe 'second level, single field, array value' do
    it_behaves_like 'a command',
                    with_name: 'set_vcard',
                    with_called_name: 'set_vcard2_multi',
                    with_input_args: [
                      user: 'admin@jabber.local',
                      'org.orgunit[]': %w[Marketing Production]
                    ],
                    with_called_args: [
                      user: 'admin',
                      host: 'jabber.local',
                      name: 'ORG',
                      subname: 'ORGUNIT',
                      contents: %w[Marketing Production]
                    ]
  end

  describe 'mixed, multiple fields, mixed' do
    describe 'integration test', :vcr do
      let(:action) do
        JabberAdmin.set_vcard!(
          user: 'admin@jabber.local',
          fn: 'The Admin',
          'n.given': 'Aang',
          'org.orgunit[]': %w[Marketing Production]
        )
      end

      it 'raises no errors' do
        expect { action }.not_to raise_error
      end
    end
  end
end
