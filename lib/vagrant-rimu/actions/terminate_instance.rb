require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      # This terminates the running server, if there is one.
      class TerminateInstance < AbstractAction
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_rimu::action::terminate_instance")
        end

        def execute(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_rimu.terminating"))
            client = env[:rimu_api]
            begin
              client.servers.cancel(env[:machine].id.to_i)
              env[:machine].id = nil
            rescue ::Rimu::RimuAPI::RimuRequestError, ::Rimu::RimuAPI::RimuResponseError => e
              raise Errors::ApiError, {:stderr=>e}
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
