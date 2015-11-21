module VagrantPlugins
  module Rimu
    module Actions
      class ListDistributions
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          rimu_api = env[:rimu_api]
          env[:ui].info '%-6s %s' % ['Distro Code', 'Distro Description']
          rimu_api.distributions.each do |dist|
            env[:ui].info '%-6s %s' % [dist.distro_code, dist.distro_description]
          end
          @app.call(env)
        end
      end
    end
  end
end
