# frozen_string_literal: true

require 'vcr'

VCR.configure do |conf|
  conf.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  conf.hook_into :webmock
  conf.configure_rspec_metadata!
end
