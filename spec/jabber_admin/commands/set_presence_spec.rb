# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::SetPresence do
  it_behaves_like 'a command',
                  with_name: 'set_presence',
                  with_input_kwargs: {
                    user: 'admin@ejabberd.local/bot',
                    type: 'available',
                    show: 'chat',
                    status: 'Listening',
                    priority: '7'
                  },
                  with_called_kwargs: {
                    user: 'admin',
                    host: 'ejabberd.local',
                    resource: 'bot',
                    type: 'available',
                    show: 'chat',
                    status: 'Listening',
                    priority: '7'
                  }
end
