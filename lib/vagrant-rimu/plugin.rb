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
        end
    end
end
