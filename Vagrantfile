REQUIRED_PLUGINS = %w(vagrant-rimu)

Vagrant.configure('2') do |config|
  config.vm.provider :rimu do |provider, override|
    override.ssh.private_key_path = 'test/test_rimu_id_rsa'
    override.ssh.insert_key = true
    provider.api_key = ENV['RIMU_API_KEY']
    provider.host_name = 'rimu.example.com'
    provider.disk_space_mb = 4000
  end
  config.vm.provision "shell", inline: "echo 'done' > ~/provision"
end
