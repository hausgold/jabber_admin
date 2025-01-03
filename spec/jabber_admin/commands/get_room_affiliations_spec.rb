# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::GetRoomAffiliations do
  let(:room) { 'room1@conference.ejabberd.local' }
  let(:host) { room.split('@').last }
  let(:action) { JabberAdmin.get_room_affiliations!(room: room) }

  context 'when the room exists', :vcr do
    before { JabberAdmin.create_room(room: room, host: host) }

    context 'with affiliations' do
      before do
        JabberAdmin.set_room_affiliation(room: room, user: 'tom@localhost')
      end

      it_behaves_like 'a command',
                      with_name: 'get_room_affiliations',
                      with_input_kwargs: {
                        room: 'room1@conference.ejabberd.local'
                      },
                      with_called_kwargs: {
                        name: 'room1',
                        service: 'conference.ejabberd.local'
                      }

      it 'returns the room affiliations' do
        expect(action).to include(a_hash_including({
                                                     'username' => 'tom',
                                                     'domain' => 'localhost'
                                                   }))
      end
    end

    context 'without affiliations' do
      let(:room) { 'room2@conference.ejabberd.local' }

      it_behaves_like 'a command',
                      with_name: 'get_room_affiliations',
                      with_input_kwargs: {
                        room: 'room2@conference.ejabberd.local'
                      },
                      with_called_kwargs: {
                        name: 'room2',
                        service: 'conference.ejabberd.local'
                      }

      it 'returns empty room affiliations' do
        expect(action).to eql([])
      end
    end
  end

  context 'when the room does not exist', :vcr do
    let(:room) { 'vroom@conference.ejabberd.local' }

    it 'raises an error' do
      expect { action }.to raise_error(JabberAdmin::CommandError)
    end
  end
end
