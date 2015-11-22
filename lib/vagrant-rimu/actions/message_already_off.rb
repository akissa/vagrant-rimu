module VagrantPlugins
  module Rimu
    module Actions
      class MessageAlreadyOff
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_rimu.already_status", :status => :off))
          @app.call(env)
        end
      end
    end
  end
end
