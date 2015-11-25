require 'log4r'

module VagrantPlugins
  module Rimu
    module Actions
      class Reload
        def initialize(app, env)
          @app = app
          @client = env[:rimu_api]
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::reload')
        end

        def call(env)
          env[:ui].info I18n.t('vagrant_rimu.reloading')
          @client.servers.reboot(@machine.id.to_i)

          @app.call(env)
        end
      end
    end
  end
end
