require 'rimu'

module VagrantPlugins
  module Rimu
    module Helpers
      module Client
        def client
           @client ||= ApiClient.new(@machine)
        end
      end

      class ApiClient
        include Vagrant::Util::Retryable
        attr_reader :client

        def initialize(machine)
          @config = machine.provider_config
          @logger = Log4r::Logger.new('vagrant::rimu::apiclient')
          @client = Rimu.new({
              :api_key => @config.api_key,
              :api_url => @config.api_url || nil,
          })
        end
      end
    end
  end
end
