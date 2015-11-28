module VagrantPlugins
  module Rimu
    module Actions
      class ListDistributions
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info '%-15s %s' % ['Distro Code', 'Distro Description']
          env[:rimu_api].distributions.each do |dist|
            env[:ui].info '%-15s %s' % [dist.distro_code, dist.distro_description]
          end
          @app.call(env)
        end
      end
    end
  end
end
