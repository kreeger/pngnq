# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pngnq/version'

Gem::Specification.new do |gem|
  gem.name          = "pngnq"
  gem.version       = Pngnq::VERSION
  gem.authors       = ["Ben Kreeger"]
  gem.email         = ["ben@kree.gr"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'cocaine'
  gem.add_runtime_dependency 'posix-spawn'

  gem.add_development_dependency 'rspec'
end
