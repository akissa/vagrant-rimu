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
          client.servers.reboot(@machine.id.to_i)

          @app.call(env)
        end
      end
    end
  end
end
