require 'log4r'

require 'vagrant-rimu/actions/ssh_utils'

module VagrantPlugins
  module Rimu
    module Actions
      class Rebuild < AbstractAction
        include Vagrant::Util::Retryable
        include VagrantPlugins::Rimu::Actions::SshUtils

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::rebuild')
        end

        # rubocop:disable Metrics/AbcSize
        def execute(env)
          client = env[:rimu_api]
          env[:ui].info I18n.t('vagrant_rimu.rebuilding')
          
          params = {
            :instantiation_options => {
                :domain_name => @machine.provider_config.host_name,
                :password => @machine.provider_config.root_password,
                :distro => @machine.provider_config.distro_code,
                :control_panel => @machine.provider_config.control_panel,
            },
            :instantiation_via_clone_options => {
                :domain_name => @machine.provider_config.host_name,
                :vps_order_oid_to_clone => @machine.provider_config.vps_to_clone,
            },
            :is_just_minimal_init => @machine.provider_config.minimal_init,
            :vps_parameters => {
                :disk_space_mb => @machine.provider_config.disk_space_mb,
                :memory_mb => @machine.provider_config.memory_mb,
                :disk_space_2_mb => @machine.provider_config.disk_space_2_mb,
            },
          }
          params.delete(:instantiation_via_clone_options) if @machine.provider_config.vps_to_clone.nil?
          params.delete(:instantiation_options) if params.has_key?(:instantiation_via_clone_options)
          if @machine.provider_config.root_password
            root_pass = @machine.provider_config.root_password
          else
            root_pass = Digest::SHA2.new.update(@machine.provider_config.api_key).to_s
          end
          if params.has_key?(:instantiation_options)
            params[:instantiation_options][:password] = root_pass
          end

          begin
            client.servers.reinstall(@machine.id.to_i, params)
          rescue ::Rimu::RimuAPI::RimuRequestError, ::Rimu::RimuAPI::RimuResponseError => e
            raise Errors::ApiError, {:stderr=>e}
          end
          
          switch_user = @machine.provider_config.setup?
          user = @machine.config.ssh.username
          if switch_user
            @machine.config.ssh.username = 'root'
            @machine.config.ssh.password = root_pass
          end

          retryable(:tries => 120, :sleep => 10) do
            next if env[:interrupted]
            raise 'not ready' unless @machine.communicate.ready?
          end

          # upload root ssh key
          upload_key(env)

          @machine.config.ssh.username = user
          
          @app.call(env)
        end
      end
    end
  end
end
