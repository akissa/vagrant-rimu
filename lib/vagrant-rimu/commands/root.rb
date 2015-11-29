module VagrantPlugins
  module Rimu
    module Commands
      COMMANDS = [
        { name: :'billing-methods', file: 'billing_methods', clazz: 'BillingMethods' },
        { name: :'distributions', file: 'distributions', clazz: 'Distributions' },
        { name: :'servers', file: 'list_servers', clazz: 'ListServers' },
        { name: :'move-vps', file: 'move', clazz: 'Move' },
        { name: :'rebuild', file: 'rebuild', clazz: 'Rebuild' },
      ]

      class Root < Vagrant.plugin('2', :command)
        def self.synopsis
          I18n.t('vagrant_rimu.commands.root_synopsis')
        end

        def initialize(argv, env)
          @env = env
          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)
          @commands = Vagrant::Registry.new

          COMMANDS.each do |cmd|
            @commands.register(cmd[:name]) do
              require_relative cmd[:file]
              Commands.const_get(cmd[:clazz])
            end
          end

          super(argv, env)
        end

        def execute
          command_class = @commands.get(@sub_command.to_sym) if @sub_command
          return usage unless command_class && @sub_command
          command_class.new(@sub_args, @env).execute(@sub_command)
        end

        def usage
          @env.ui.info I18n.t('vagrant_rimu.commands.root_usage')
          @env.ui.info ''
          @env.ui.info I18n.t('vagrant_rimu.commands.available_subcommands')
          @commands.each do |key, value|
            @env.ui.info "     #{key.to_s.ljust(20)} #{value.synopsis}"
          end
          @env.ui.info ''
        end
      end
    end
  end
end
