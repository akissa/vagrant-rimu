require 'log4r'

module VagrantPlugins
  module Rimu
    module Actions
      class ReadState
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @client = env[:rimu_api]
          @logger = Log4r::Logger.new('vagrant_rimu::action::read_state')
        end

        def call(env)
          env[:machine_state] = read_state(@client, @machine)
          @logger.info "Machine state is '#{env[:machine_state]}'"
          @app.call(env)
        end

        def read_state(client, machine)
          return :not_created if machine.id.nil?
          server = client.servers.status(machine.id)
          return :not_created if server.nil?
          status = server.running_state
          return :not_created if status.nil?
          states = {
            'RUNNING' => :active,
            'NOTRUNNING' => :off,
            'RESTARTING' => :shutting_down,
            'POWERCYCLING' => :shutting_down,
          }
          states[status.to_s]
        end
      end
    end
  end
end
