module VagrantPlugins
  module Rimu
    module Errors
      class RimuError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_rimu.errors")
      end

      class JSONError < RimuError
        error_key(:json)
      end

      class PublicKeyError < RimuError
        error_key(:public_key)
      end

      class RsyncError < RimuError
        error_key(:rsync)
      end
    end
  end
end
