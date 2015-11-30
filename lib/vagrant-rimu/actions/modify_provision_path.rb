require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class ModifyProvisionPath < AbstractAction
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::rimu::modify_provision_path')
        end

        def execute(env)
          # check if provisioning is enabled
          enabled = true
          enabled = env[:provision_enabled] if env.has_key?(:provision_enabled)
          return @app.call(env) unless enabled

          username = @machine.ssh_info()[:username]

          # change ownership of the provisioning path recursively to the
          # ssh user
          #
          @machine.config.vm.provisioners.each do |provisioner|
            cfg = provisioner.config
            path = cfg.upload_path if cfg.respond_to? :upload_path
            path = cfg.provisioning_path if cfg.respond_to? :provisioning_path
            @machine.communicate.sudo("chown -R #{username} #{path}",
              :error_check => false)
          end

          @app.call(env)
        end
      end
    end
  end
end
