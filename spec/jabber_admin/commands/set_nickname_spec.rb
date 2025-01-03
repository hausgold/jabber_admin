# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SetNickname do
  it_behaves_like 'a command',
                  with_name: 'set_nickname',
                  with_input_kwargs: {
                    user: 'tom@ejabberd.local',
                    nick: 'TomTom'
                  },
                  with_called_kwargs: {
                    user: 'tom',
                    host: 'ejabberd.local',
                    nickname: 'TomTom'
                  }
end
