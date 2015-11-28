require 'vagrant'

module VagrantPlugins
  module Rimu
    module Errors
      class RimuError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_rimu.errors")
      end

      class PublicKeyError < RimuError
        error_key(:public_key)
      end

      class RsyncError < RimuError
        error_key(:rsync)
      end

      class ApiError < RimuError
        error_key(:api_error)
      end

      class NoArgRequiredForCommand < RimuError
        error_key(:no_args)
      end
    end
  end
end
