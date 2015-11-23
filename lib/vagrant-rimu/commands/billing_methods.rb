module VagrantPlugins
  module Rimu
    module Commands
      class BillingMethods < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant rimu billing_methods [options]'
          end
          argv = parse_options(opts)
          return unless argv
          with_target_vms(argv, provider: :rimu) do |machine|
            machine.action('billing_methods')
          end
        end
      end
    end
  end
end
