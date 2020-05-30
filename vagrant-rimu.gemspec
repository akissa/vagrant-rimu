# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vagrant-rimu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Andrew Colin Kissa']
  gem.email         = ['andrew@topdog.za.net']
  gem.license       = 'MPL-2.0'
  gem.description   = %q{Rimuhosting provider for Vagrant.}
  gem.summary       = %q{Rimuhosting provider for Vagrant.}
  gem.homepage      = 'https://github.com/akissa/vagrant-rimu'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'vagrant-rimu'
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 2.0.0'
  gem.extra_rdoc_files = ['README.md']
  gem.version       = VagrantPlugins::Rimu::VERSION

  gem.add_runtime_dependency 'rimu', '>= 0.1.0'
  gem.add_runtime_dependency 'colorize', '~> 0.7.3'
  gem.add_runtime_dependency 'terminal-table', '~> 1.4.5'
  gem.add_development_dependency 'bundler', '~> 1.5'
  gem.add_development_dependency 'rspec', '~> 3.1.0'
  gem.add_development_dependency 'rspec-its', '~> 1.0.1'
  gem.add_development_dependency 'rspec-expectations', '~> 3.1.2'
  gem.add_development_dependency 'rake'
end
