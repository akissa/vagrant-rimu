require 'pathname'

require 'vagrant-rimu/plugin'
require 'vagrant-rimu/logging'

module VagrantPlugins
  module Rimu
    lib_path = Pathname.new(File.expand_path("../vagrant-rimu", __FILE__))
    autoload :Errors, lib_path.join('errors')
    
    def self.init_i18n
      I18n.load_path << File.expand_path('locales/en.yml', source_root)
      I18n.reload!
    end

    def self.init_logging
      Logging.init
    end

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    def self.public_key(private_key_path)
      File.read("#{private_key_path}.pub")
    rescue
      raise Errors::PublicKeyError, :path => "#{private_key_path}.pub"
    end
  end
end
