module VagrantPlugins
  module Rimu
    module Commands
      class Move < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant rimu move [options]'
          end
          argv = parse_options(opts)
          return unless argv
          with_target_vms(argv, provider: :rimu) do |machine|
            machine.action('move')
          end
        end
      end
    end
  end
end
