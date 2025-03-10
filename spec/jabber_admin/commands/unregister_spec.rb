# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::Unregister do
  it_behaves_like 'a command',
                  with_name: 'unregister',
                  with_input_kwargs: {
                    user: 'tom@ejabberd.local'
                  },
                  with_called_kwargs: {
                    check_res_body: false,
                    user: 'tom',
                    host: 'ejabberd.local'
                  }
end
