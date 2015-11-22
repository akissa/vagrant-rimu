module VagrantPlugins
  module Rimu
    module Actions
      class ListDistributions
        def initialize(app, env)
          @app = app
          @client = env[:rimu_api]
        end

        def call(env)
          env[:ui].info '%-6s %s' % ['Distro Code', 'Distro Description']
          @client.distributions.each do |dist|
            env[:ui].info '%-6s %s' % [dist.distro_code, dist.distro_description]
          end
          @app.call(env)
        end
      end
    end
  end
end
