require 'vagrant-rimu/commands/utils'
require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class ListServers < AbstractAction
        include VagrantPlugins::Rimu::Commands::Utils

        def initialize(app, _env)
          @app = app
        end

        def execute(env)
          rows = []
          env[:rimu_api].orders.orders.each do |o|
            rows << [o.order_oid, o.domain_name, o.location["data_center_location_code"], o.host_server_oid, o.running_state]
          end
          display_table(env, ['ID', 'Hostname', 'Data Centre', 'Host Server', 'Status'], rows)

          @app.call(env)
        end
      end
    end
  end
end
