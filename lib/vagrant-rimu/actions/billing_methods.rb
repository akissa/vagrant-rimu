require 'vagrant-rimu/commands/utils'
require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class BillingMethods < AbstractAction
        include VagrantPlugins::Rimu::Commands::Utils

        def initialize(app, _env)
          @app = app
        end

        def execute(env)
          rows = []
          env[:rimu_api].billing_methods.each do |b|
            rows << [b.billing_oid, b.billing_method_type, b.description]
          end
          display_table(env, ['ID', 'Type', 'Description'], rows)

          @app.call(env)
        end
      end
    end
  end
end
