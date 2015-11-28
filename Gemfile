source 'https://rubygems.org'

gemspec

group :test do
  gem 'codecov', :require => false
  gem 'simplecov', :require => false
  gem 'coveralls', :require => false
  gem 'codeclimate-test-reporter', require: false
end

group :development do
  if ENV['VAGRANT_VERSION']
    gem 'vagrant', :git => 'https://github.com/mitchellh/vagrant.git',
    tag: ENV['VAGRANT_VERSION']
  else
    gem 'vagrant', :git => 'https://github.com/mitchellh/vagrant.git'
  end
  gem 'rubocop', '0.29.0', :require => false
end

group :plugins do
  gem 'bundler', '>= 1.5.2', '< 1.8.0'
  gem 'vagrant-rimu', :path => '.'
end
