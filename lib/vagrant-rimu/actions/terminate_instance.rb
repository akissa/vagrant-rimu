require 'log4r'

module VagrantPlugins
  module Rimu
    module Actions
      # This terminates the running server, if there is one.
      class TerminateInstance
        def initialize(app, _env)
          @app = app
          @client = env[:rimu_api]
          @logger = Log4r::Logger.new("vagrant_rimu::action::terminate_instance")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_rimu.terminating"))
            @client.servers.cancel(env[:machine].id.to_i)
            env[:machine].id = nil
          end

          @app.call(env)
        end
      end
    end
  end
end
