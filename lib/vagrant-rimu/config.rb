module VagrantPlugins
  module Rimu
    class Config < Vagrant.plugin('2', :config)
      # The API key for accessing Rimu.
      #
      # @return [String]
      attr_accessor :api_key

      # Rimu api url.
      #
      # @return [String]
      attr_accessor :api_url

      # Rimu distribution to install
      #
      # @return [String]
      attr_accessor :distro_code

      # Rimu data_centre
      # DCDALLAS | DCLONDON | DCSYDNEY | DCBRISBANE | DCAUCKLAND | DCFRANKFURT
      #
      # @return [String]
      attr_accessor :data_centre

      # File system image size on primary partition in MB
      #
      # @return [Fixnum]
      attr_accessor :disk_space_mb

      # File system image size on secondary partition in MB
      # Mostly not used.
      #
      # @return [Fixnum]
      attr_accessor :disk_space_2_mb

      # Memory size in MB
      #
      # @return [Fixnum]
      attr_accessor :memory_mb

      # You can specify a vps_type
      # LOW_CONTENTION | REGULAR | DEDICATED
      #
      # @return [String]
      attr_accessor :vps_type

      # The label you want to give the server.
      # It will need to be a fully qualified domain name (FQDN).
      #
      # @return [String]
      attr_accessor :host_name

      # The password to use when setting up the server.
      # If not provided, a random one will be set.
      #
      # @return [String]
      attr_accessor :root_password

      # The control panel to install on the VPS.
      # Currently only webmin is supported
      #
      # @return [String]
      attr_accessor :control_panel

      # Set this if you want the newly setup VPS to be a clone of another VPS
      # The clone source VPS will be paused for a few seconds to a few minutes
      # to take the snapshot.
      #
      # @return [Fixnum]
      attr_accessor :vps_to_clone

      # The reason for requiring more than one IP address.
      # The number of IP addresses will be limited.
      #
      # @return [String]
      attr_accessor :extra_ip_reason

      # How many IPs you need.  Typically 1.
      #
      # @return [Fixnum]
      attr_accessor :num_ips

      # This option is often used for customers wanting to setup a VPS
      # with private IPs
      #
      # @return [String]
      attr_accessor :private_ips

      # Set the billing id if you want to control how it is billed.
      # run `vagrant rimu billing-methods` to find what billing methods/ids
      # you have setup on your account.
      #
      # @return [Fixnum]
      attr_accessor :billing_id

      # The host server on which to setup the server.
      # Typically you will want to leave this blank and let the API decide
      # what is best/available.
      #
      # An exception may be if you are a customer with a dedicated server
      # that is a VPS host.  And in that case you may want to force a VPS
      # to be setup on a particular server of yours.
      #
      # @return [Fixnum]
      attr_accessor :host_server_id

      # Do minimal setup work.
      #
      # @return [bool]
      attr_accessor :minimal_init

      attr_accessor :setup

      alias_method :setup?, :setup

      def initialize
        @api_key = UNSET_VALUE
        @api_url = UNSET_VALUE
        @distro_code = UNSET_VALUE
        @setup = UNSET_VALUE
        @disk_space_mb = UNSET_VALUE
        @disk_space_2_mb = UNSET_VALUE
        @memory_mb = UNSET_VALUE
        @vps_type = UNSET_VALUE
        @host_name = UNSET_VALUE
        @root_password = UNSET_VALUE
        @control_panel = UNSET_VALUE
        @vps_to_clone = UNSET_VALUE
        @extra_ip_reason = UNSET_VALUE
        @num_ips = UNSET_VALUE
        @private_ips = UNSET_VALUE
        @billing_id = UNSET_VALUE
        @host_server_id = UNSET_VALUE
        @minimal_init = UNSET_VALUE
        @data_centre = UNSET_VALUE
      end

      def finalize!
        @api_key = ENV['RIMU_API_KEY'] if @api_key == UNSET_VALUE
        @api_url = ENV['RIMU_URL'] if @api_url == UNSET_VALUE
        @distro_code = "centos6.64" if @distro_code == UNSET_VALUE
        @disk_space_mb = 20000 if @disk_space_mb == UNSET_VALUE
        @disk_space_2_mb = nil if @disk_space_2_mb == UNSET_VALUE
        @memory_mb = 1024 if @memory_mb == UNSET_VALUE
        @vps_type = nil if @vps_type == UNSET_VALUE
        @host_name = nil if @host_name == UNSET_VALUE
        @root_password = nil if @root_password == UNSET_VALUE
        @control_panel = nil if @control_panel == UNSET_VALUE
        @vps_to_clone = nil if @vps_to_clone == UNSET_VALUE
        @extra_ip_reason = nil if @extra_ip_reason == UNSET_VALUE
        @num_ips = nil if @num_ips == UNSET_VALUE
        @private_ips = nil if @private_ips == UNSET_VALUE
        @billing_id = nil if @billing_oid == UNSET_VALUE
        @host_server_id = nil if @host_server_id == UNSET_VALUE
        @minimal_init = nil if @minimal_init == UNSET_VALUE
        @data_centre = nil if @data_centre == UNSET_VALUE
        @setup = true if @setup == UNSET_VALUE
      end

      def validate(machine)
        errors = []
        errors << I18n.t('vagrant_rimu.config.api_key') if !@api_key
        errors << I18n.t('vagrant_rimu.config.host_name') if !@host_name
        if @host_name
          errors << I18n.t('vagrant_rimu.config.invalid_host_name', {:host_name => @host_name}) \
            unless @hostname.match(/\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b/)
        end

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
