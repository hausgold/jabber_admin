
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jabber_admin/version"

Gem::Specification.new do |spec|
  spec.name          = "jabber_admin"
  spec.version       = JabberAdmin::VERSION
  spec.authors       = ["Henning Vogt"]
  spec.email         = ["henning.vogt@hausgold.de"]

  spec.summary       = %q{Library for the Ejabberd RESTful admin API}
  spec.description   = %q{Library for the Ejabberd RESTful admin API}
  spec.homepage      = "https://github.com/hausgold/jabber_admin"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", ">= 0.14"
  spec.add_dependency "activesupport", ">= 5"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.15"
end
