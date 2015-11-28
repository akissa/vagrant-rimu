require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class MessageAlreadyOff < AbstractAction
        def initialize(app, _env)
          @app = app
        end

        def execute(env)
          env[:ui].info(I18n.t("vagrant_rimu.already_status", :status => :off))
          @app.call(env)
        end
      end
    end
  end
end
