require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class MessageWillNotStop < AbstractAction
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
        end

        def execute(env)
          env[:ui].info(I18n.t('vagrant_rimu.will_not_stop', {:name => @machine.name}))
          @app.call(env)
        end
      end
    end
  end
end
