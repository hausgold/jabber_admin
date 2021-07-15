# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jabber_admin/version'

Gem::Specification.new do |spec|
  spec.name        = 'jabber_admin'
  spec.version     = JabberAdmin::VERSION
  spec.authors     = ['Henning Vogt', 'Hermann Mayer']
  spec.licenses    = ['MIT']
  spec.email       = ['henning.vogt@hausgold.de', 'hermann.mayer@hausgold.de']

  spec.summary     = 'Library for the ejabberd RESTful admin API'
  spec.description = 'Library for the ejabberd RESTful admin API'
  spec.homepage    = 'https://github.com/hausgold/jabber_admin'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.required_ruby_version = '~> 2.5'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.2.0'
  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.2'

  spec.add_development_dependency 'bundler', '>= 1.16', '< 3'
  spec.add_development_dependency 'irb', '~> 1.2'
  spec.add_development_dependency 'railties', '>= 4.2.0', '< 6.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.93'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.43'
  spec.add_development_dependency 'simplecov', '< 0.18'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
  spec.add_development_dependency 'yard', '~> 0.9.18'
  spec.add_development_dependency 'yard-activesupport-concern', '~> 0.0.1'
end
