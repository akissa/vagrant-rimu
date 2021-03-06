# Rimuhosting Vagrant Provider

`vagrant-rimuhosting` is a provider plugin for Vagrant that supports the
management of [Rimuhosting](https://www.rimuhosting.com/) VPS's.

[![Build Status](https://travis-ci.org/akissa/vagrant-rimu.svg?branch=master)](https://travis-ci.org/akissa/vagrant-rimu)
[![Code Climate](https://codeclimate.com/github/akissa/vagrant-rimu/badges/gpa.svg)](https://codeclimate.com/github/akissa/vagrant-rimu)
[![Test Coverage](https://codeclimate.com/github/akissa/vagrant-rimu/badges/coverage.svg)](https://codeclimate.com/github/akissa/vagrant-rimu/coverage)
[![Gem Version](https://badge.fury.io/rb/vagrant-rimu.svg)](https://badge.fury.io/rb/vagrant-rimu)
[![MPLv2 License](https://img.shields.io/badge/license-MPLv2-blue.svg?style=flat-square)](https://www.mozilla.org/MPL/2.0/)

Current Features include:
- create and destroy VPS's
- power on and off VPS's
- rebuild a VPS (destroys and ups with same IP address)
- provision a VPS
- move a VPS to a different host server
- setup a SSH public key for authentication
- create a new user account during VPS creation

## Install

Install the provider plugin using the Vagrant command-line interface:

    vagrant plugin install vagrant-rimu

## Configure

Once the provider has been installed, you will need to configure your
project to use it.

The most basic `Vagrantfile` to create a VPS on Rimu is shown below
(with the optional options commented out):

```ruby
Vagrant.configure('2') do |config|

  config.vm.provider :rimu do |provider, override|
    override.ssh.insert_key = true
    override.ssh.private_key_path = '~/.ssh/id_rsa'

    provider.api_key = 'YOUR RIMU API KEY'
    provider.host_name = 'rimu.example.com'
    # provider.distro_code = 'centos6.64'
    # provider.data_centre = 'DCDALLAS'
    # provider.memory_mb = 1024
    # provider.disk_space_mb = 40000
    # provider.disk_space_2_mb = 40000
    # provider.vps_type = 'REGULAR'
    # provider.root_password = 'zxcvbnm'
    # provider.control_panel = 'webmin'
    # provider.vps_to_clone = 999
    # provider.extra_ip_reason = 'TLS/SSL for example.com and example.net'
    # provider.num_ips = 2
    # provider.private_ips = true
    # provider.billing_id = 9999
    # provider.host_server_id = 9999
    # provider.minimal_init = true
  end
end
```

**Configuration Requirements**
- You *must* specify the `override.ssh.private_key_path` option to enable
  authentication.
- You *must* specify your Rimu API Key. This can be found/generated in the RIMU
  [control panel](https://rimuhosting.com/cp/apikeys.jsp).
- You *must* specify the `provider.host_name` option, and it should be a
  fully qualified domain name (FQDN).

## Run

After creating your project's `Vagrantfile` with the required configuration
attributes described above, you may create a new VPS with the following
command:

    $ vagrant up --provider=rimu

This command will create a new VPS, setup your SSH key for authentication,
create a new user account, and run the provisioners you have configured.

**Supported Commands**

The provider supports the following Vagrant sub-commands:
- `vagrant destroy` - Destroys the Rimu VPS.
- `vagrant rebuild` - Destroys the Rimu VPS and recreates it with the
  same IP address which was previously assigned.
- `vagrant halt` - Powers off the Rimu VPS.
- `vagrant reload` - Reboots the Rimu VPS.
- `vagrant provision` - Runs the configured provisioners and rsyncs any
  specified `config.vm.synced_folder` folders.
- `vagrant status` - Outputs the status (active, off, not created) for the
  Rimu VPS.
- `vagrant ssh` - Logs into the Rimu VPS using the configured user account.
- `vagrant rimu` - Rimu provider specific commands

**Rimu Specific Commands**

The Rimu specific commands are available as sub commands of `vagrant rimu`.
The `vagrant rimu` command provides the following sub commands:
- `distributions` - Lists the distributions supported.
- `servers` - Lists the servers under your account.
- `billing methods` - Lists the billing methods setup for your account.
- `move-vps` - Moves your VPS to a different host.

## Contributing

1. Fork it (https://github.com/akissa/vagrant-rimu/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

All code is licensed under the
[MPLv2 License](https://github.com/akissa/vagrant-rimu/blob/master/LICENSE).
