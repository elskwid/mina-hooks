# -*- encoding: utf-8 -*-

require File.expand_path("../lib/mina/hooks/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "mina-hooks"
  gem.version       = Mina::Hooks::VERSION
  gem.summary       = %q{Provides local task hooks that run before and after the mina commands.}
  gem.description   = %q{Provides local task hooks that run before and after the mina commands.}
  gem.license       = "MIT"
  gem.authors       = ["Don Morrison"]
  gem.email         = "don@elskwid.net"
  gem.homepage      = "https://github.com/elskwid/mina-hooks#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mina", "~> 0.3"

  gem.add_development_dependency "bundler", "~> 1.2"
  gem.add_development_dependency "minitest", "~> 5.0"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rubygems-tasks", "~> 0.2"
  gem.add_development_dependency "yard", "~> 0.8"
end
