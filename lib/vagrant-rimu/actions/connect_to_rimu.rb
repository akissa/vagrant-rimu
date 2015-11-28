require 'log4r'
require 'rimu'

module VagrantPlugins
  module Rimu
    module Actions
      class ConnectToRimu
        def initialize(app, env)
          @app = app
          @config = env[:machine].provider_config
          @logger = Log4r::Logger.new('vagrant_rimu::action::connect_to_rimu')
        end

        def call(env)
          @logger.info('Connecting to Rimu api_url...')
          rimu = ::Rimu::RimuAPI.new({:api_url => @config.api_url, :api_key=> @config.api_key})
          env[:rimu_api] = rimu
          @app.call(env)
        end
      end
    end
  end
end
