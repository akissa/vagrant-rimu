require 'simplecov'

if ENV['CI']=='true'
  require 'codecov'
  require 'coveralls'
  require 'codeclimate-test-reporter'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter,
      SimpleCov::Formatter::Codecov,
      CodeClimate::TestReporter::Formatter,
  ]
  Coveralls.wear!
  CodeClimate::TestReporter.start
end
SimpleCov.start

Dir['lib/**/*.rb'].each do|file|
  require_string = file.match(/lib\/(.*)\.rb/)[1]
  require require_string
end

require 'rspec/its'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

I18n.load_path << File.expand_path('locales/en.yml', Pathname.new(File.expand_path('../../', __FILE__)))

VagrantPlugins::Rimu::Logging.init
