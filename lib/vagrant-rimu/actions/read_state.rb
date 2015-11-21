module VagrantPlugins
  module Rimu
    module Actions
      class ReadState
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant_rimu::action::read_state')
        end

        def call(env)
          env[:machine_state] = read_state(@machine)
          @logger.info "Machine state is '#{env[:machine_state]}'"
          @app.call(env)
        end

        def read_state(machine)
          return :not_created if machine.id.nil?
          rimu_server = Provider.rimu_server(machine)
          return :not_created if rimu_server.nil?
          status = rimu_server.running_state
          return :not_created if status.nil?
          states = {
            "RUNNING" => :active,
            "NOTRUNNING" => :off,
            "RESTARTING" => :shutting_down,
            "POWERCYCLING" => :shutting_down,
          }
          states[status.to_s]
        end
      end
    end
  end
end
