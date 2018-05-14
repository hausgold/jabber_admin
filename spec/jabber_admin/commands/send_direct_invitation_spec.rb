# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SendDirectInvitation do
  it_behaves_like 'a command',
                  with_name: 'send_direct_invitation',
                  with_input_args: [
                    room: 'room2@conference.ejabberd.local',
                    users: ['tom@ejabberd.local', 'admin@ejabberd.local'],
                    password: '',
                    reason: 'Check this out!'
                  ],
                  with_called_args: [
                    name: 'room2',
                    service: 'conference.ejabberd.local',
                    users: 'tom@ejabberd.local:admin@ejabberd.local',
                    password: '',
                    reason: 'Check this out!'
                  ]
end
