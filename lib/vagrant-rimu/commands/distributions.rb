module VagrantPlugins
  module Rimu
    module Commands
      class Distributions < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant rimu distributions [options]'
          end
          argv = parse_options(opts)
          return unless argv
          with_target_vms(argv, provider: :rimu) do |machine|
            machine.action('list_distributions')
          end
        end
      end
    end
  end
end
