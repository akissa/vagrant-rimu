require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class StartInstance < AbstractAction
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new("vagrant_rimu::action::start_instance")
        end

        def execute(env)
          client = env[:rimu_api]
          env[:ui].info I18n.t('vagrant_rimu.starting')
          begin
            result = client.servers.start(@machine.id.to_i)
            raise StandardError, "No response from the API" if result.nil?
            raise StandardError, "VPS is not be running" if result.running_state != 'RUNNING'
          rescue StandardError => e
            raise Errors::ApiError, {:stderr=>e}
          end
          env[:ui].info(I18n.t("vagrant_rimu.ready"))
          @app.call(env)
        end
      end
    end
  end
end
