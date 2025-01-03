# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::MucRegisterNick do
  it_behaves_like 'a command',
                  with_name: 'muc_register_nick',
                  with_input_kwargs: {
                    user: 'tom@ejabberd.local',
                    nick: 'TomTom'
                  },
                  with_called_kwargs: {
                    jid: 'tom@ejabberd.local',
                    serverhost: 'ejabberd.local',
                    nick: 'TomTom'
                  }
end
