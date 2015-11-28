require 'vagrant-rimu/commands/rimu_command'

module VagrantPlugins
  module Rimu
    module Commands
      class ListServers < RimuCommand
        def self.synopsis
          I18n.t('vagrant_rimu.commands.list_servers')
        end

        def cmd(name, argv, env)
          fail Errors::NoArgRequiredForCommand, cmd: name unless argv.size == 0
          env[:machine].action('list_servers')
        end
      end
    end
  end
end
