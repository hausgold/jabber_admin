# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SendStanza do
  it_behaves_like 'a command',
                  with_name: 'send_stanza',
                  with_input_args: [
                    from: 'tom@ejabberd.local',
                    to: 'room1@conference.ejabberd.local',
                    stanza: '<message><body>Hey!</body></message>'
                  ],
                  with_called_args: [
                    from: 'tom@ejabberd.local',
                    to: 'room1@conference.ejabberd.local',
                    stanza: '<message><body>Hey!</body></message>'
                  ]
end
