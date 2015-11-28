require 'vagrant-rimu/commands/rimu_command'

module VagrantPlugins
  module Rimu
    module Commands
      class BillingMethods < RimuCommand
        def self.synopsis
          I18n.t('vagrant_rimu.commands.billing_methods')
        end

        def cmd(name, argv, env)
          fail Errors::NoArgRequiredForCommand, cmd: name unless argv.size == 0
          env[:machine].action('billing_methods')
        end
      end
    end
  end
end
