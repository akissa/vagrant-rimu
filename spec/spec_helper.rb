require 'simplecov'
require 'codecov'
require 'coveralls'
require 'codeclimate-test-reporter'

SimpleCov.start
if ENV['CI']=='true'
  SimpleCov.formatters = [
    SimpleCov::Formatter::Codecov,
    Coveralls::SimpleCov::Formatter,
    CodeClimate::TestReporter::Formatter,
  ]
  Coveralls.wear!
  CodeClimate::TestReporter.start
end

Dir['lib/**/*.rb'].each do|file|
  require_string = file.match(/lib\/(.*)\.rb/)[1]
  require require_string
end

require 'rspec/its'

I18n.load_path << File.expand_path('locales/en.yml', Pathname.new(File.expand_path('../../', __FILE__)))

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
