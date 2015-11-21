require 'pathname'

module VagrantPlugins
  module Rimu
    module Actions
      include Vagrant::Action::Builtin

      def self.action_list_distributions
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConnectToRimu
          b.use ListDistributions
        end
      end

      action_root = Pathname.new(File.expand_path('../actions', __FILE__))
      autoload :ConnectToRimu, action_root.join('connect_to_rimu')
      autoload :ListDistributions, action_root.join('list_distributions')
    end
  end
end
