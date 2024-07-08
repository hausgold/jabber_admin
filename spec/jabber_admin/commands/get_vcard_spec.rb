# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::GetVcard do
  before { alternative_config! }

  describe 'first level, single field, scalar value' do
    it_behaves_like(
      'a command',
      with_name: 'get_vcard',
      with_input_args: [
        :fn,
        { user: 'admin@jabber.local' }
      ],
      with_called_args: [
        user: 'admin',
        host: 'jabber.local',
        name: 'FN'
      ],
      stubbed_response: '{"content":"The Admin"}'
    ) do
      describe 'return value', :vcr do
        it 'returns the expected scalar value' do
          expect(action.call).to eql('The Admin')
        end

        context 'when there is no vCard' do
          it 'returns nil' do
            expect(action.call).to be_nil
          end
        end
      end
    end
  end

  describe 'second level, single field, scalar value' do
    it_behaves_like(
      'a command',
      with_name: 'get_vcard',
      with_called_name: 'get_vcard2',
      with_input_args: [
        'n.given',
        { user: 'admin@jabber.local' }
      ],
      with_called_args: [
        user: 'admin',
        host: 'jabber.local',
        name: 'N',
        subname: 'GIVEN'
      ],
      stubbed_response: '{"content":"Aang"}'
    ) do
      describe 'return value', :vcr do
        it 'returns the expected scalar value' do
          expect(action.call).to eql('Aang')
        end
      end
    end
  end

  describe 'second level, single field, array value' do
    it_behaves_like(
      'a command',
      with_name: 'get_vcard',
      with_called_name: 'get_vcard2_multi',
      with_input_args: [
        'org.orgunit[]',
        { user: 'admin@jabber.local' }
      ],
      with_called_args: [
        user: 'admin',
        host: 'jabber.local',
        name: 'ORG',
        subname: 'ORGUNIT'
      ],
      stubbed_response: '["Marketing","Production"]'
    ) do
      describe 'return value', :vcr do
        it 'returns the expected array' do
          expect(action.call).to match_array(%w[Marketing Production])
        end
      end
    end
  end

  describe 'mixed, multiple fields, mixed' do
    describe 'integration test', :vcr do
      let(:action) do
        JabberAdmin.get_vcard!(
          :fn,
          'n.given',
          'org.orgunit[]',
          'un.known_single',
          'un.known_array[]',
          user: 'admin@jabber.local'
        )
      end
      let(:payload) do
        {
          fn: 'The Admin',
          'n.given' => 'Aang',
          'org.orgunit' => %w[Marketing Production],
          'un.known_single' => nil,
          'un.known_array' => nil
        }
      end

      it 'raises no errors' do
        expect { action }.not_to raise_error
      end

      it 'returns the expected values' do
        expect(action).to match(payload)
      end
    end
  end
end
