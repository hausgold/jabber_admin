# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::Register do
  it_behaves_like 'a command',
                  with_name: 'register',
                  with_input_kwargs: {
                    user: 'tom@ejabberd.local',
                    password: 'password'
                  },
                  with_called_kwargs: {
                    check_res_body: false,
                    user: 'tom',
                    host: 'ejabberd.local',
                    password: 'password'
                  }
end
