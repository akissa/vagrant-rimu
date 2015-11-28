require 'log4r'
require 'vagrant'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class Create < AbstractAction
        include Vagrant::Util::Retryable
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::create')
        end

        # rubocop:disable Metrics/AbcSize
        def execute(env)
          client = env[:rimu_api]
          env[:ui].info I18n.t('vagrant_rimu.creating')
          params = {
            :billing_oid => @machine.provider_config.billing_id,
            :dc_location => @machine.provider_config.data_centre,
            :host_server_oid => @machine.provider_config.host_server_id,
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
            :ip_request => {
                :extra_ip_reason => @machine.provider_config.extra_ip_reason,
                :num_ips => @machine.provider_config.num_ips,
                :requested_ips => @machine.provider_config.private_ips,
            },
            :is_just_minimal_init => @machine.provider_config.minimal_init,
            :vps_parameters => {
                :disk_space_mb => @machine.provider_config.disk_space_mb,
                :memory_mb => @machine.provider_config.memory_mb,
                :disk_space_2_mb => @machine.provider_config.disk_space_2_mb,
            },
            :vps_type => @machine.provider_config.vps_type,
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
          result = client.servers.create(params)
          @machine.id = result.order_oid
          env[:ui].info I18n.t('vagrant_rimu.ip_address', {:ip => result.allocated_ips["primary_ip"]})
          switch_user = @machine.provider_config.setup?
          user = @machine.config.ssh.username
          if switch_user
            @machine.config.ssh.username = 'root'
            @machine.config.ssh.password = root_pass
          end
          if params.has_key?(:instantiation_options)
            retryable(:tries => 120, :sleep => 10) do
              next if env[:interrupted]
              raise 'not ready' if !@machine.communicate.ready?
            end
          end
          @machine.config.ssh.username = user
          @app.call(env)
        end
        # rubocop:enable Metrics/AbcSize

        def recover(env)
          return if env['vagrant.error'].is_a?(Vagrant::Errors::VagrantError)
          if @machine.state.id != :not_created
            terminate(env)
          end
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Actions.destroy, destroy_env)
        end
      end
    end
  end
end
