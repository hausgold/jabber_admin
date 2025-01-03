# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::UnsubscribeRoom do
  it_behaves_like 'a command',
                  with_name: 'unsubscribe_room',
                  with_input_kwargs: {
                    user: 'tom@ejabberd.local/dummy',
                    room: 'room1@conference.ejabberd.local'
                  },
                  with_called_kwargs: {
                    user: 'tom@ejabberd.local/dummy',
                    room: 'room1@conference.ejabberd.local'
                  }
end
