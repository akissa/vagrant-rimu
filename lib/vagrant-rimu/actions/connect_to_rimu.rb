require 'log4r'
require 'rimu'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class ConnectToRimu < AbstractAction
        def initialize(app, env)
          @app = app
          @config = env[:machine].provider_config
          @logger = Log4r::Logger.new('vagrant_rimu::action::connect_to_rimu')
        end

        def execute(env)
          @logger.info('Connecting to Rimu api_url...')
          rimu = ::Rimu::RimuAPI.new({:api_url => @config.api_url, :api_key=> @config.api_key})
          env[:rimu_api] = rimu
          @app.call(env) unless @app.nil?
        end
      end
    end
  end
end
