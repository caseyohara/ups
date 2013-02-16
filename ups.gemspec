# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ups/version'

Gem::Specification.new do |gem|
  gem.name          = "ups"
  gem.version       = UPS::VERSION
  gem.authors       = ["Casey O'Hara"]
  gem.email         = ["casey.ohara@me.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://github.com/caseyohara/ups"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "i18n"
  gem.add_runtime_dependency "active_support", "~> 3.0.0"
  gem.add_runtime_dependency "nokogiri", "~> 1.5.6"
  gem.add_runtime_dependency "typhoeus", "~> 0.6.1"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard", "1.4.0"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "vcr", "2.4.0"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "growl"
end
