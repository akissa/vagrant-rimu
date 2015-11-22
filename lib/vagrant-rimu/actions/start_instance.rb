require 'log4r'

module VagrantPlugins
  module Rimu
    class StartInstance
      def initialize(app, env)
        @app = app
        @client = env[:rimu_api]
        @machine = env[:machine]
        @logger = Log4r::Logger.new("vagrant_rimu::action::start_instance")
      end

      def call(env)
        env[:ui].info I18n.t('vagrant_rimu.starting')
        begin
          result = @client.servers.start(@machine.id)
          raise StandardError, "No response from the API" if result.nil?
          raise StandardError, "VPS is not be running" if result.running_state != 'RUNNING'
        rescue StandardError => e
          raise Errors::ApiError, "#{e}"
        end
        env[:ui].info(I18n.t("vagrant_rimu.ready"))
        @app.call(env)
      end
    end
  end
end
