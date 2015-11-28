require 'vagrant-rimu/commands/utils'
require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      class ListDistributions < AbstractAction
        include VagrantPlugins::Rimu::Commands::Utils

        def initialize(app, _env)
          @app = app
        end

        def execute(env)
          rows = []
          env[:rimu_api].distributions.each do |dist|
            rows << [dist.distro_code, dist.distro_description]
          end
          display_table(env, ['Distro Code', 'Distro Description'], rows)

          @app.call(env)
        end
      end
    end
  end
end
