source 'https://rubygems.org'

# Specify your gem's dependencies in vagrant-rimu.gemspec
gemspec
gem 'simplecov', :require => false, :group => :test
gem 'codecov', :require => false, :group => :test

group :development do
    if ENV['VAGRANT_VERSION']
        gem 'vagrant', :git => 'https://github.com/mitchellh/vagrant.git',
        tag: ENV['VAGRANT_VERSION']
    else
        gem 'vagrant', :git => 'https://github.com/mitchellh/vagrant.git'
    end
    gem 'pry'
end

group :plugins do
    gem 'vagrant-rimu', :path => '.'
end
