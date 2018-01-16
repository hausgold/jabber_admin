require "simplecov"
SimpleCov.start do
  add_filter 'spec'
end

require "bundler/setup"
require "jabber_admin"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Set JabberAdmin configuration
# Is available in all Specs
JabberAdmin.configure do |config|
  config.api_host = 'https://jabber.example.local'
  config.admin = "admin"
  config.password = "password"
end
