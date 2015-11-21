source 'https://rubygems.org'

group :test do
    gem 'codecov', :require => false
    gem 'simplecov', :require => false
    gem "coveralls", :require => false
end

group :development do
    if ENV['VAGRANT_VERSION']
        gem 'vagrant', :git => 'https://github.com/mitchellh/vagrant.git',
        tag: ENV['VAGRANT_VERSION']
    else
        gem 'vagrant', :git => 'https://github.com/mitchellh/vagrant.git'
    end
end

group :plugins do
    gem 'vagrant-rimu', :path => '.'
    gemspec
end
