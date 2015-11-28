require 'log4r'

module VagrantPlugins
  module Rimu
    module Actions
      class Move
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::move')
        end

        def call(env)
          client = env[:rimu_api]
          env[:ui].info I18n.t('vagrant_rimu.move')
          fail 'not implemented'
          @app.call(env)
        end
      end
    end
  end
end
