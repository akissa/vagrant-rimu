require 'log4r'
require 'vagrant'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class Move < AbstractAction
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::move')
        end

        # rubocop:disable Metrics/AbcSize
        def execute(env)
          client = env[:rimu_api]

          env[:ui].info I18n.t('vagrant_rimu.moving')

          begin
            result = client.servers.move(@machine.id.to_i)
          rescue ::Rimu::RimuAPI::RimuRequestError, ::Rimu::RimuAPI::RimuResponseError => e
            raise Errors::ApiError, {:stderr=>e}
          end

          @machine.id = result.order_oid
          env[:ui].info I18n.t('vagrant_rimu.ip_address', {:ip => result.allocated_ips["primary_ip"]})

          switch_user = @machine.provider_config.setup?
          user = @machine.config.ssh.username
          @machine.config.ssh.username = 'root' if switch_user

          retryable(:tries => 120, :sleep => 10) do
            next if env[:interrupted]
            raise 'not ready' if !@machine.communicate.ready?
          end

          @machine.config.ssh.username = user

          @app.call(env)
        end
      end
    end
  end
end
