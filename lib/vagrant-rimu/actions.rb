require 'pathname'

require 'vagrant/action/builder'

module VagrantPlugins
  module Rimu
    # rubocop:disable Metrics/ModuleLength
    module Actions
      include Vagrant::Action::Builtin

      # This action is called to terminate the remote machine.
      def self.action_destroy
        new_builder.tap do |b|
          b.use Call, DestroyConfirm do |env, b1|
            if env[:result]
              b1.use ConfigValidate
              b1.use ConnectToRimu
              b1.use Call, ReadState do |env1, b2|
                if env1[:machine_state] == :not_created
                  b2.use MessageNotCreated
                else
                  b2.use TerminateInstance
                end
              end
            else
              b1.use MessageWillNotDestroy
            end
          end
        end
      end

      # This action is called to read the SSH info of the machine. The
      # resulting state is expected to be put into the `:machine_ssh_info`
      # key.
      def self.action_read_ssh_info
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ReadSSHInfo
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state`
      # key.
      def self.action_read_state
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ReadState
        end
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            if env[:machine_state] == :not_created
              b1.use MessageNotCreated
            else
              b1.use SSHExec
            end
          end
        end
      end

      def self.action_ssh_run
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            if env[:machine_state] == :not_created
              b1.use MessageNotCreated
            else
              b1.use SSHRun
            end
          end
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use Provision
              b1.use ModifyProvisionPath
              b1.use SyncedFolders
            when :off
              env[:ui].info I18n.t('vagrant_rimu.off')
            when :not_created
              b1.use MessageNotCreated
            end
          end
        end
      end

      def self.action_up
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            case env[:machine_state]
            when :not_created
              b1.use Create
              b1.use SetupSudo
              b1.use SetupUser
              b1.use action_provision
            when :off
              b1.use StartInstance
              b1.use action_provision
            else
              b1.use MessageAlreadyCreated
            end
          end
        end
      end

      # This action is called to halt the remote machine.
      def self.action_halt
        new_builder.tap do |b|
          b.use MessageWillNotStop
          # b.use ConfigValidate
          # b.use ConnectToRimu
          # b.use Call, ReadState do |env, b1|
          #   case env[:machine_state]
          #     when :not_created
          #       b1.use MessageNotCreated
          #     when :off
          #       b1.use MessageAlreadyOff
          #     else
          #       b1.use StopInstance
          #   end
          # end
        end
      end

      def self.action_reload
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            case env[:machine_state]
            when :not_created
              b1.use MessageNotCreated
            when :off
              env[:ui].info I18n.t('vagrant_rimu.off')
            else
              b1.use Reload
              b1.use action_provision
            end
          end
        end
      end

      def self.action_rebuild
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            case env[:machine_state]
            when :active, :off
              b1.use Rebuild
              b1.use SetupSudo
              b1.use SetupUser
              b1.use action_provision
            when :not_created
              b1.use MessageNotCreated
            end
          end
        end
      end

      def self.action_list_distributions
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ListDistributions
        end
      end

      def self.action_list_servers
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ListServers
        end
      end

      def self.action_billing_methods
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use BillingMethods
        end
      end

      def self.action_move
        new_builder.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Call, ReadState do |env, b1|
            case env[:machine_state]
            when :active, :off
              b1.use Move
            when :not_created
              b1.use MessageNotCreated
            end
          end
        end
      end

      action_root = Pathname.new(File.expand_path('../actions', __FILE__))
      autoload :ConnectToRimu, action_root.join('connect_to_rimu')
      autoload :StopInstance, action_root.join('stop_instance')
      autoload :TerminateInstance, action_root.join('terminate_instance')
      # autoload :IsCreated, action_root.join('is_created')
      # autoload :IsStopped, action_root.join('is_stopped')
      autoload :ReadSSHInfo, action_root.join('read_ssh_info')
      autoload :ReadState, action_root.join('read_state')
      autoload :StartInstance, action_root.join('start_instance')
      autoload :Create, action_root.join('create')
      autoload :SetupSudo, action_root.join('setup_sudo')
      autoload :SetupUser, action_root.join('setup_user')
      autoload :ModifyProvisionPath, action_root.join('modify_provision_path')
      autoload :Reload, action_root.join('reload')
      autoload :Rebuild, action_root.join('rebuild')
      autoload :ListDistributions, action_root.join('list_distributions')
      autoload :ListServers, action_root.join('list_servers')
      autoload :BillingMethods, action_root.join('billing_methods')
      autoload :Move, action_root.join('move')
      autoload :MessageAlreadyOff, action_root.join('message_already_off')
      autoload :MessageNotCreated, action_root.join('message_not_created')
      autoload :MessageWillNotDestroy, action_root.join('message_will_not_destroy')
      autoload :MessageAlreadyCreated, action_root.join('message_already_created')
      autoload :MessageWillNotStop, action_root.join('message_will_not_stop')
      
      private

      def self.new_builder
        Vagrant::Action::Builder.new
      end
    end
  end
end
