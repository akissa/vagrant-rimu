module VagrantPlugins
  module Rimu
    module Actions
      class MessageWillNotDestroy
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_rimu.will_not_destroy', {:name => @machine.name}))
          @app.call(env)
        end
      end
    end
  end
end
