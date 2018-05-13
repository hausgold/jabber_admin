# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SubscribeRoom do
  it_behaves_like 'a command',
                  with_name: 'subscribe_room',
                  with_input_args: [
                    user: 'tom@ejabberd.local/dummy',
                    nick: 'TomTom',
                    room: 'room1@conference.ejabberd.local',
                    nodes: [
                      'urn:xmpp:mucsub:nodes:messages',
                      'urn:xmpp:mucsub:nodes:affiliations'
                    ]
                  ],
                  with_called_args: [
                    check_res_body: false,
                    user: 'tom@ejabberd.local/dummy',
                    nick: 'TomTom',
                    room: 'room1@conference.ejabberd.local',
                    nodes: 'urn:xmpp:mucsub:nodes:messages,' \
                      'urn:xmpp:mucsub:nodes:affiliations'
                  ]
end
