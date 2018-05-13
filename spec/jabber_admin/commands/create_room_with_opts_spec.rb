# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::CreateRoomWithOpts do
  it_behaves_like 'a command',
                  with_name: 'create_room_with_opts',
                  with_input_args: [
                    room: 'room2@conference.ejabberd.local',
                    host: 'ejabberd.local',
                    members_only: true
                  ],
                  with_called_args: [
                    name: 'room2',
                    service: 'conference.ejabberd.local',
                    host: 'ejabberd.local',
                    options: [{ 'name' => 'members_only', 'value' => 'true' }]
                  ]
end
