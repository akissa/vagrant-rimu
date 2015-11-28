require 'colorize'

module VagrantPlugins
  module Rimu
    module Actions
      class AbstractAction
        def call(env)
          execute(env)
        # rubocop:disable Lint/RescueException
        rescue Errors::RimuError, SystemExit, Interrupt => e
          raise e
        rescue Exception => e
          puts I18n.t('vagrant_rimu.errors.global_error').red unless e.message && e.message.start_with?('Caught Error:')
          raise $!, "Caught Error: #{$!}", $!.backtrace
        end
        # rubocop:enable Lint/RescueException
      end
    end
  end
end
