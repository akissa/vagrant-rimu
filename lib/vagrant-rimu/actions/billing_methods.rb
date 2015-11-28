module VagrantPlugins
  module Rimu
    module Actions
      class BillingMethods
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info '%-20s %-20s %s' % ['ID', 'Type', 'Description']
          env[:rimu_api].billing_methods.each do |b|
            env[:ui].info '%-20s %-20s %s' % [b.billing_oid, b.billing_method_type, b.description]
          end
          @app.call(env)
        end
      end
    end
  end
end
