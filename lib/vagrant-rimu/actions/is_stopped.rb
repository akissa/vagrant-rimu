module VagrantPlugins
  module Rimu
    module Actions
      class IsStopped
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:result] = env[:machine].state.id == :stopped

          @app.call(env)
        end
      end
    end
  end
end
