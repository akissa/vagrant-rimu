require 'vagrant-rimu/commands/abstract_command'

module VagrantPlugins
  module Rimu
    module Commands
      class RimuCommand < AbstractCommand
        def before_cmd(_name, _argv, env)
          VagrantPlugins::Rimu::Actions::ConnectToRimu.new(nil, env).call(env)
        end
      end
    end
  end
end
