REQUIRED_PLUGINS = %w(vagrant-rimu)

Vagrant.configure('2') do |config|
  config.vm.provider :rimu do |provider, override|
    override.ssh.private_key_path = 'test/test_rimu_id_rsa'
    provider.api_key = ENV['RIMU_API_KEY']
    provider.host_name = 'rimu.example.com'
  end
  config.vm.provision "shell", inline: "echo 'done' > ~/provision"
end
