# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::RegisteredUsers do
  it_behaves_like 'a command',
                  with_name: 'registered_users',
                  with_input_kwargs: {
                    host: 'ejabberd.local'
                  },
                  with_called_kwargs: {
                    check_res_body: false,
                    host: 'ejabberd.local'
                  }
end
