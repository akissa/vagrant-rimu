module VagrantPlugins
  module Rimu
    module Actions
      class ListServers
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          heading = '%-10s %-30s %-20s %-15s %-15s' % ['ID', 'Hostname', 'Data Centre', 'Host Server', 'Status']
          env[:ui].info heading
          env[:rimu_api].orders.orders.each do |o|
            row = '%-10s %-30s %-20s %-15s %-15s' % [o.order_oid, o.domain_name, o.location["data_center_location_code"], o.host_server_oid, o.running_state]
            env[:ui].info row
          end
          @app.call(env)
        end
      end
    end
  end
end
