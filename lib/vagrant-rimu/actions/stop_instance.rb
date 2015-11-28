require 'log4r'

require 'vagrant-rimu/actions/abstract_action'

module VagrantPlugins
  module Rimu
    module Actions
      # This stops the running instance.
      class StopInstance < AbstractAction
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_rimu::action::stop_instance')
        end

        def execute(env)
          if env[:machine].state.id == :stopped
            env[:ui].info(I18n.t('vagrant_rimu.already_status', :status => env[:machine].state.id))
          else
            shutdown(env)
          end
          
          @app.call(env)
        end
        
        def shutdown(env)
          env[:ui].info(I18n.t('vagrant_rimu.stopping'))
          client = env[:rimu_api]
          client.servers.shutdown(env[:machine].id.to_i)
        end
      end
    end
  end
end
