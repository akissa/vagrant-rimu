module VagrantPlugins
  module Rimu
    module Commands
      class Rebuild < Vagrant.plugin('2', :command)
        def self.synopsis
          I18n.t('vagrant_rimu.commands.rebuild')
        end

        def execute
          with_target_vms(nil, provider: :rimu) do |machine|
            machine.action(:rebuild)
          end
          0
        end
      end
    end
  end
end
