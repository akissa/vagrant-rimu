module VagrantPlugins
  module Rimu
    module Actions
      class ListServers
        def initialize(app, env)
          @app = app
          @client = env[:rimu_api]
        end

        def call(env)
          heading = '%-8s %-20s %-20s %-15s %-15s' % ['ID', 'Hostname', 'Data Centre', 'Host Server', 'Status']
          env[:ui].info heading
          @client.orders.orders.each do |o|
            row = '%-8s %-20s %-20s %-15s %-15s' % [o.order_oid, o.domain_name, o.location["data_center_location_code"], o.host_server_oid, o.running_state]
            env[:ui].info row
          end
          @app.call(env)
        end
      end
    end
  end
end
