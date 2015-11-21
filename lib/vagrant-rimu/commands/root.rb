require 'optparse'

module VagrantPlugins
  module Rimu
    module Commands
      class Root < Vagrant.plugin('2', :command)
        def self.synopsis
          'query Rimu for available distributions'
        end

        def initialize(argv, env)
          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = Vagrant::Registry.new

          @subcommands.register(:distributions) do
            require File.expand_path('../distributions', __FILE__)
            Distributions
          end

          super(argv, env)
        end

        def execute
          if @main_args.include?('-h') || @main_args.include?('--help')
            return help
          end
          command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help if !command_class || !@sub_command
          @logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")
          command_class.new(@sub_args, @env).execute
        end

        def help
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant rimu <subcommand> [<args>]'
            o.separator ''
            o.separator 'Available subcommands:'
            keys = []
            @subcommands.each { |key, _value| keys << key.to_s }
            keys.sort.each do |key|
              o.separator "     #{key}"
            end
            o.separator ''
            o.separator 'For help on any individual subcommand run `vagrant rimu <subcommand> -h`'
          end
          @env.ui.info(opts.help, prefix: false)
        end
      end
    end
  end
end
