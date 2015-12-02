require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class ReadState < AbstractAction
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant_rimu::action::read_state')
        end

        def execute(env)
          client = env[:rimu_api]
          env[:machine_state] = read_state(client, @machine)
          @logger.info I18n.t('vagrant_rimu.states.current_state', {:state => env[:machine_state]})
          @app.call(env)
        end

        def read_state(client, machine)
          return :not_created if machine.id.nil?
          server = client.servers.status(machine.id.to_i)
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
