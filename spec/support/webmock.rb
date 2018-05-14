# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |config|
  # Some specs stub HTTP request, but this is only for the specific
  # example useful. Reset WebMock before each example and allow HTTP
  # requests as normal.
  config.before do
    WebMock.allow_net_connect!
  end
end
