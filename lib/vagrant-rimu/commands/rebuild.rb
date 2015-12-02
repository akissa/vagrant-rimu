require 'optparse'

module VagrantPlugins
  module Rimu
    module Commands
      class Rebuild < Vagrant.plugin('2', :command)
        def self.synopsis
          I18n.t('vagrant_rimu.commands.rebuild')
        end

        def execute
          opts = OptionParser.new do |o|
            I18n.t('vagrant_rimu.commands.rebuild_usage')
          end
          argv = parse_options(opts)
          with_target_vms(argv) do |machine|
            machine.action(:rebuild)
          end
          0
        end
      end
    end
  end
end
