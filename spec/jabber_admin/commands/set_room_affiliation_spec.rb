# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SetRoomAffiliation do
  it_behaves_like 'a command',
                  with_name: 'set_room_affiliation',
                  with_input_args: [
                    user: 'tom@ejabberd.local',
                    room: 'room2@conference.ejabberd.local',
                    affiliation: 'member'
                  ],
                  with_called_args: [
                    name: 'room2',
                    service: 'conference.ejabberd.local',
                    jid: 'tom@ejabberd.local',
                    affiliation: 'member'
                  ]
end
