require 'pathname'

require 'vagrant/action/builder'

module VagrantPlugins
  module Rimu
    module Actions
      include Vagrant::Action::Builtin

      # This action is called to terminate the remote machine.
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, DestroyConfirm do |env, b2|
            if env[:result]
              b2.use ConfigValidate
              b.use Call, IsCreated do |env2, b3|
                if !env2[:result]
                  b3.use MessageNotCreated
                  next
                end
              end
              b2.use ConnectToRimu
              b2.use TerminateInstance
            else
              b2.use MessageWillNotDestroy
            end
          end
        end
      end

      # This action is called to read the SSH info of the machine. The
      # resulting state is expected to be put into the `:machine_ssh_info`
      # key.
      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ReadSSHInfo
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ReadState
        end
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use SSHExec
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use SSHRun
          end
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use ConnectToRimu
          builder.use Call, IsCreated do |env, b|
            case env[:machine_state]
            when :active
              b.use Provision
              b.use ModifyProvisionPath
              b.use SyncedFolders
            when :off
              env[:ui].info I18n.t('vagrant_rimu.off')
            when :not_created
              b.use MessageNotCreated
            end
          end
        end
      end

      def self.action_up
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use ConnectToRimu
          builder.use Call, IsCreated do |env, b|
            case env[:machine_state]
            when :active
              b.use MessageAlreadyCreated
            when :off
              b.use StartInstance
              b.use action_provision
            when :not_created
              b.use Create
              b.use SetupSudo
              b.use SetupUser
              b.use action_provision
            end
          end
        end
      end

      # This action is called to halt the remote machine.
      def self.action_halt
        Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, IsCreated do |env, b1|
            if env[:result]
              b1.use Call, IsStopped do |env2, b2|
                if env2[:result]
                  b2.use MessageAlreadyOff
                else
                  b2.use ConnectToRimu
                  b2.use PowerOff
                end
              end
            else
              b1.use MessageNotCreated
            end
          end
        end
      end

      def self.action_reload
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use ConnectToRimu
          builder.use Call, IsCreated do |env, b|
            case env[:machine_state]
            when :active
              b.use Reload
              b.use action_provision
            when :off
              env[:ui].info I18n.t('vagrant_rimu.off')
            when :not_created
              b.use MessageNotCreated
            end
          end
        end
      end

      def self.action_rebuild
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use ConnectToRimu
          builder.use Call, IsCreated do |env, b|
            case env[:machine_state]
            when :active, :off
              b.use Rebuild
              b.use SetupSudo
              b.use SetupUser
              b.use action_provision
            when :not_created
              b.use MessageNotCreated
            end
          end
        end
      end

      def self.action_list_distributions
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ListDistributions
        end
      end

      def self.action_list_servers
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use ListServers
        end
      end

      def self.action_billing_methods
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use BillingMethods
        end
      end

      def self.action_move
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectToRimu
          b.use Move
        end
      end

      action_root = Pathname.new(File.expand_path('../actions', __FILE__))
      autoload :ConnectToRimu, action_root.join('connect_to_rimu')
      autoload :StopInstance, action_root.join('stop_instance')
      autoload :TerminateInstance, action_root.join('terminate_instance')
      autoload :IsCreated, action_root.join('is_created')
      autoload :IsStopped, action_root.join('is_stopped')
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
    end
  end
end
