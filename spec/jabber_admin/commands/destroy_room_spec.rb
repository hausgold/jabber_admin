# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::DestroyRoom do
  it_behaves_like 'a command',
                  with_name: 'destroy_room',
                  with_input_args: [
                    room: 'room1@conference.ejabberd.local',
                    host: 'ejabberd.local'
                  ],
                  with_called_args: [
                    name: 'room1',
                    service: 'conference.ejabberd.local',
                    host: 'ejabberd.local'
                  ]
end
