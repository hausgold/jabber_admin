# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'countless/rake_tasks'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# Configure all code statistics directories
Countless.configure do |config|
  config.stats_base_directories = [
    { name: 'Top-levels', dir: 'lib',
      pattern: %r{/lib(/jabber_admin)?/[^/]+\.rb$} },
    { name: 'Top-levels specs', test: true, dir: 'spec',
      pattern: %r{/spec(/jabber_admin)?/[^/]+_spec\.rb$} },
    { name: 'Commands', pattern: 'lib/jabber_admin/commands/**/*.rb' },
    { name: 'Commands specs', test: true,
      pattern: 'spec/jabber_admin/commands/**/*_spec.rb' }
  ]
end
