require "vagrant-rimu/actions"
require "vagrant-linode/helpers/client"

module VagrantPlugins
  module Rimu
    class Provider < Vagrant.plugin('2', :provider)
      # def self.rimu_server(machine, opts = {})
      #   client = Helpers::ApiClient.new(machine)
      #   unless @rimu_servers
      #     @rimu_servers = client.orders.orders
      #   end
      #   if opts[:refresh] && machine.id
      #     @rimu_servers.delete_if { |d| d.order_oid.to_s == machine.id }
      #     rimu_server = client.orders.order(machine.id.to_i)
      #     @rimu_servers << rimu_server
      #   elsif machine.id
      #     rimu_server = @rimu_servers.find { |d| d.order_oid.to_s == machine.id }
      #   end
      #   unless rimu_server
      #     name = machine.config.vm.hostname || machine.name
      #     rimu_server = @rimu_servers.find { |d| d.domain_name == name.to_s }
      #     machine.id = rimu_server.domain_name if rimu_server
      #   end
      #   rimu_server ||= { status: :not_created }
      # end

      def initialize(machine)
        @machine = machine
      end

      def action(name)
        action_method = "action_#{name}"
        return Actions.send(action_method) if Actions.respond_to?(action_method)
        nil
      end

      def ssh_info
        # rimu_server = Provider.rimu_server(@machine)
        # return nil if rimu_server.running_state != "RUNNING"
        # ip_address = rimu_server.allocated_ips["primary_ip"]
        # return {
        #   :host => ip_address,
        #   :port => '22',
        #   :username => 'root',
        #   :private_key_path => @machine.config.ssh.private_key_path,
        # }
        
      end

      def machine_id_changed
        if @machine.id
          Provider.rimu_server(@machine, refresh: true)
        end
      end

      def state
        env = @machine.action("read_state")
        state_id = env[:machine_state]
        long = short = state_id.to_s
        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        id = @machine.id.nil? ? 'new' : @machine.id
        "RimuVPS (#{id})"
      end
    end
  end
end
