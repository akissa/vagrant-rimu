require 'log4r'

module VagrantPlugins
  module Rimu
    module Actions
      class ConnectToRimu
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_rimu::action::connect_to_rimu')
        end

        def call(env)
          config = env[:machine].provider_config
          api_url = config.api_url
          api_key = config.api_key
          @logger.info('Connecting to Rimu api_url...')
          rimu = Rimu.new({:api_url => api_url, :api_key=>api_key})
          env[:rimu_api] = rimu
          @app.call(env)
        end
      end
    end
  end
end
