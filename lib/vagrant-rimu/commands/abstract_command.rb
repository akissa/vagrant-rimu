require 'colorize'

module VagrantPlugins
  module Rimu
    module Commands
      class AbstractCommand < Vagrant.plugin('2', :command)
        def initialize(argv, env)
          @env = env
          super(normalize_args(argv), env)
        end

        def execute(name)
          env = {}
          with_target_vms(nil, provider: :rimu) do |machine|
            env[:machine] = machine
            env[:ui] = @env.ui
          end

          before_cmd(name, @argv, env)

          cmd(name, @argv, env)
          @env.ui.info('')
        # rubocop:disable Lint/RescueException
        rescue Errors::RimuError, SystemExit, Interrupt => e
          raise e
        rescue Exception => e
          puts I18n.t('vagrant_rimu.errors.global_error').red unless e.message
          raise e
        end
        # rubocop:enable Lint/RescueException

        def normalize_args(args)
          return args if args.nil?
          args.pop if args.size > 0 && args.last == '--'
          args
        end

        def before_cmd(_name, _argv, _env)
        end

        def cmd(_name, _argv, _env)
          fail 'Command not implemented. \'cmd\' method must be overridden in all subclasses'
        end
      end
    end
  end
end
