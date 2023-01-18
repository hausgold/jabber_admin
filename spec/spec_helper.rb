# frozen_string_literal: true

$VERBOSE = nil
require 'simplecov'
SimpleCov.command_name 'specs'

require 'bundler/setup'
require 'jabber_admin'
require 'active_support'

# Load all support helpers and shared examples
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Enable the focus inclusion filter and run all when no filter is set
  # See: http://bit.ly/2TVkcIh
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |conf|
    conf.syntax = :expect
  end

  # Reset the gem configuration to its testing defaults before each example
  config.before { reset_configuration! }
end
