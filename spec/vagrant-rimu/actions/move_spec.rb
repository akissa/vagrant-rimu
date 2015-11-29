require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::Move do
  let(:ssh) { double('ssh') }
  let(:servers) { double('servers') }
  let(:machine) { double('machine') }
  let(:move) { double('move') }
  let(:communicate) { double('communicate') }
  let(:id) { '200' }

  let(:config) do
    double.tap do |config|
      config.stub(:api_url) { nil }
      config.stub(:api_key) { 'foo' }
      # config.stub(:host_name) { 'rimu.example.com' }
      # config.stub(:root_password) { nil }
      # config.stub(:distro_code) { nil }
      # config.stub(:control_panel) { nil }
      # config.stub(:vps_to_clone) { nil }
      # config.stub(:minimal_init) { nil }
      # config.stub(:disk_space_mb) { nil }
      # config.stub(:memory_mb) { nil }
      # config.stub(:disk_space_2_mb) { nil }
      config.stub(:setup?) { true }
      ssh.stub(:username) { 'rimu' }
      ssh.stub(:username=) { 'rimu' }
      ssh.stub(:private_key_path) { 'test/test_rimu_id_rsa' }
      config.stub(:ssh) { ssh }
    end
  end

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        move.stub(:order_oid) { id }
        move.stub(:allocated_ips) { {:primary_ip => '192.168.1.10'} }
        servers.stub(:move) { move }
        os.stub(:servers) { servers }
      end
      machine.stub(:id) { id }
      machine.stub(:id=) { id }
      env[:machine] = machine
      env[:machine].stub(:config) { config }
      env[:machine].stub(:provider_config) { config }
      communicate.stub(:ready?) { true }
      env[:machine].stub(:communicate) { communicate }
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    it 'moves server to different host' do
      expect(env[:machine].provider_config).to receive(:setup?)
      expect(env[:machine].communicate).to receive(:ready?)
      expect(env[:machine].config.ssh).to receive(:username=).with(ssh.username)
      expect(env[:rimu_api].servers).to receive(:move)
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::Move.new(app, env)
      @action.call(env)
    end
  end
end
