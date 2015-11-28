require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class IsStopped < AbstractAction
        def initialize(app, _env)
          @app = app
        end

        def execute(env)
          env[:result] = env[:machine].state.id == :stopped

          @app.call(env)
        end
      end
    end
  end
end
