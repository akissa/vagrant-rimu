require 'optparse'
require 'vagrant-rimu/commands/abstract_command'

module VagrantPlugins
  module Rimu
    module Commands
      class Rebuild < AbstractCommand
        def self.synopsis
          I18n.t('vagrant_rimu.commands.rebuild')
        end

        def cmd(name, argv, env)
          fail Errors::NoArgRequiredForCommand, cmd: name unless argv.size == 0
          env[:machine].action('rebuild')
        end
      end
    end
  end
end
