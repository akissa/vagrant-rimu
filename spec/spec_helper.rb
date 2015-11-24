# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start
require 'simplecov'
require 'coveralls'

if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

SimpleCov.start

require 'rubygems'
require 'rspec'
require 'rspec/its'

Dir['lib/**/*.rb'].each do|file|
  require_string = file.match(/lib\/(.*)\.rb/)[1]
  require require_string
end

I18n.load_path << File.expand_path('locales/en.yml', Pathname.new(File.expand_path('../../', __FILE__)))

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end
