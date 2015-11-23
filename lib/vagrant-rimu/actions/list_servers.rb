module VagrantPlugins
  module Rimu
    module Actions
      class ListServers
        def initialize(app, env)
          @app = app
          @client = env[:rimu_api]
        end

        def call(env)
          env[:ui].info '%-8s %-30s %-20s %-10s %-9s' % ['ID', 'Hostname', 'Data Centre', 'Host Server', 'Status']
          @client.orders.orders.each do |o|
            env[:ui].info '%-8s %-30s %-20s %-10s %-9s' % [o.order_oid, o.domain_name, o.location["data_center_location_code"], o.host_server_oid, o.running_state]
          end
          @app.call(env)
        end
      end
    end
  end
end
