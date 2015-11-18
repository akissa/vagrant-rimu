module VagrantPlugins
    module Rimu
        module Errors
            class VagrantRimuError < Vagrant::Errors::VagrantError
                error_namespace("vagrant_rimu.errors")
            end
        end
    end
end
