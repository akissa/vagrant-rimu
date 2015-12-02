require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadSSHInfo < AbstractAction
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant_rimu::action::read_ssh_info')
        end

        def execute(env)
          client = env[:rimu_api]
          env[:machine_ssh_info] = read_ssh_info(client, @machine)

          @app.call(env)
        end

        def read_ssh_info(client, machine)
          return nil if machine.id.nil?

          # Find the machine
          server = client.orders.order(machine.id.to_i)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end

          return {
            :host => server.allocated_ips['primary_ip'],
            :port => 22,
            :username => 'root',
            :private_key_path => machine.config.ssh.private_key_path,
          }
        end
      end
    end
  end
end
