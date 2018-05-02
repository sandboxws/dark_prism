# -*- encoding: utf-8 -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dark_prism/version"

Gem::Specification.new do |spec|
  spec.name          = "dark_prism"
  spec.version       = DarkPrism::VERSION
  spec.authors       = ["Ahmed Elhossaini"]
  spec.email         = ["aelhussaini@gmail.com"]

  spec.summary       = "dark_prism-#{DarkPrism::VERSION}"
  spec.description   = %q{Simple and straightforward event dispatching for ruby}
  spec.homepage      = "https://github.com/sandboxws/dark_prism"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files           += ["LICENSE.md"]
  spec.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  spec.extra_rdoc_files = [ "README.md" ]
  spec.rdoc_options     = ["--charset=UTF-8"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.2.0"
  spec.add_dependency "google-cloud-pubsub", ">= 0.27.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11.3"
end
