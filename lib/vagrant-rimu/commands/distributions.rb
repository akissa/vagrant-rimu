require 'vagrant-rimu/commands/rimu_command'

module VagrantPlugins
  module Rimu
    module Commands
      class Distributions < RimuCommand
        def self.synopsis
          I18n.t('vagrant_rimu.commands.list_distributions')
        end

        def cmd(name, argv, env)
          fail Errors::NoArgRequiredForCommand, cmd: name unless argv.size == 0
          env[:machine].action('list_distributions')
        end
      end
    end
  end
end
