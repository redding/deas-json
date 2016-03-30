# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "deas-json/version"

Gem::Specification.new do |gem|
  gem.name        = "deas-json"
  gem.version     = Deas::Json::VERSION
  gem.authors     = ["Kelly Redding", "Collin Redding"]
  gem.email       = ["kelly@kellyredding.com", "collin.redding@me.com"]
  gem.summary     = %q{JSON helpers for Deas apps}
  gem.description = %q{JSON helpers for Deas apps}
  gem.homepage    = "http://github.com/redding/deas-json"
  gem.license     = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("assert", ["~> 2.15.1"])

  gem.add_dependency("deas",        ["~> 0.39.1"])
  gem.add_dependency("much-plugin", ["~> 0.1.0"])

end
