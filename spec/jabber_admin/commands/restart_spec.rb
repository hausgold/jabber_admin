# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::Commands::Restart do
  it_behaves_like 'a command', with_name: 'restart'
end
