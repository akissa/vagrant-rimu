module VagrantPlugins
    module Rimu
        class Config < Vagrant.plugin('2', :config)
            attr_accessor :api_key
            attr_accessor :api_url
            attr_accessor :distro_code
            attr_accessor :datacenter
            attr_accessor :setup
            attr_accessor :ssh_key_name

            alias_method :setup?, :setup

            def initialize
                @api_key = UNSET_VALUE
                @api_url = UNSET_VALUE
                @distro_code = UNSET_VALUE
                @setup = UNSET_VALUE
                @datacenter = UNSET_VALUE
                @ssh_key_name = UNSET_VALUE
            end

            def finalize!
                @api_key = ENV['RIMU_API_KEY'] if @api_key == UNSET_VALUE
                @api_url = ENV['RIMU_URL'] if @api_url == UNSET_VALUE
                @distro_code = "centos6.64" if @distro_code == UNSET_VALUE
                @setup = true if @setup == UNSET_VALUE
                @datacenter = "DALLAS" if @datacenter == UNSET_VALUE
                @ssh_key_name = "Vagrant" if @ssh_key_name == UNSET_VALUE
            end

            def validate(machine)
                errors = []
                errors << I18n.t('vagrant_rimu.config.api_key') if !@api_key

                key = machine.config.ssh.private_key_path
                key = key[0] if key.is_a?(Array)
                if !key
                    errors << I18n.t('vagrant_rimu.config.private_key')
                elsif !File.file?(File.expand_path("#{key}.pub", machine.env.root_path))
                    errors << I18n.t('vagrant_rimu.config.public_key', key: "#{key}.pub")
                end

                { 'Rimu Provider' => errors }
            end
        end
    end
end
