module VagrantPlugins
  module Rimu
    module Actions
      class BillingMethods
        def initialize(app, env)
          @app = app
          @client = env[:rimu_api]
        end

        def call(env)
          env[:ui].info '%-6s %-6s %s' % ['ID', 'Type', 'Description']
          @client.billing_methods.each do |b|
            env[:ui].info '%-6s %-6s %s' % [b.billing_oid, b.billing_method_type, b.description]
          end
          @app.call(env)
        end
      end
    end
  end
end
