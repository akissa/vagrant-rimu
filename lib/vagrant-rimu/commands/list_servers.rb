module VagrantPlugins
  module Rimu
    module Commands
      class ListServers < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant rimu servers [options]'
          end
          argv = parse_options(opts)
          return unless argv
          with_target_vms(argv, provider: :rimu) do |machine|
            machine.action('list_servers')
          end
        end
      end
    end
  end
end
