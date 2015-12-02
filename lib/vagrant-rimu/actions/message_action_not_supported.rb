require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class MessageActionNotSupported < AbstractAction
        def initialize(app, _env)
          @app = app
        end

        def execute(env)
          env[:ui].info(I18n.t('vagrant_rimu.action_not_supported'))

          @app.call(env)
        end
      end
    end
  end
end
