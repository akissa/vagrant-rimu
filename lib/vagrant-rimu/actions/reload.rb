require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class Reload < AbstractAction
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::reload')
        end

        def execute(env)
          client = env[:rimu_api]
          env[:ui].info I18n.t('vagrant_rimu.reloading')

          begin
            client.servers.reboot(@machine.id.to_i)
          rescue ::Rimu::RimuAPI::RimuRequestError, ::Rimu::RimuAPI::RimuResponseError => e
            raise Errors::ApiError, {:stderr=>e}
          end

          @app.call(env)
        end
      end
    end
  end
end
