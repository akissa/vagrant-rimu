begin
    require 'vagrant'
rescue LoadError
    raise 'The Vagrant Rimu plugin must be run within Vagrant.'
end

if Vagrant::VERSION < '1.5.0'
    raise 'The Vagrant Rimu plugin is only compatible with Vagrant 1.5+'
end

module VagrantPlugins
    module Rimu
        class Plugin < Vagrant.plugin('2')
            name 'Rimu'
            description <<-DESC
            This plugin installs a provider that allows Vagrant to manage
            virtual machines using Rimuhosting's API.
            DESC

            config(:rimu, :provider) do
                require_relative "config"
                Config
            end

            provider(:digital_ocean) do
                require_relative "provider"
                Provider
            end

            command(:rimu) do
                require_relative "commands/root"
                Commands::Root
            end

            command(:rebuild) do
                require_relative "commands/rebuild"
                Commands::Rebuild
            end
        end
    end
end
