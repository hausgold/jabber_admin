# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SendStanzaC2s do
  it_behaves_like 'a command',
                  with_name: 'send_stanza_c2s',
                  with_input_kwargs: {
                    user: 'admin@ejabberd.local/bot',
                    stanza: '<message to="room1@conference.ejabberd.local">' \
                            '<body>Hey!</body></message>'
                  },
                  with_called_kwargs: {
                    user: 'admin',
                    host: 'ejabberd.local',
                    resource: 'bot',
                    stanza: '<message to="room1@conference.ejabberd.local">' \
                            '<body>Hey!</body></message>'
                  }
end
