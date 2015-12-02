require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::Rebuild do
  let(:ssh) { double('ssh') }
  let(:servers) { double('servers') }
  let(:machine) { double('machine') }
  let(:reinstall) { double('reinstall') }
  let(:communicate) { double('communicate') }
  let(:id) { '200' }

  let(:config) do
    double.tap do |config|
      config.stub(:api_url) { nil }
      config.stub(:api_key) { 'foo' }
      config.stub(:host_name) { 'rimu.example.com' }
      config.stub(:root_password) { nil }
      config.stub(:distro_code) { nil }
      config.stub(:control_panel) { nil }
      config.stub(:vps_to_clone) { nil }
      config.stub(:minimal_init) { nil }
      config.stub(:disk_space_mb) { nil }
      config.stub(:memory_mb) { nil }
      config.stub(:disk_space_2_mb) { nil }
      config.stub(:setup?) { true }
      ssh.stub(:username) { 'rimu' }
      ssh.stub(:username=) { 'rimu' }
      ssh.stub(:password=).with(anything)
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
        servers.stub(:reinstall) { reinstall }
        os.stub(:servers) { servers }
      end
      machine.stub(:id) { id }
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
    context 'when vps_to_clone option is not set' do
      it 'reinstall the server using instantiation_options' do
        # env.stub(:interrupted) { false }
        root_passwd = Digest::SHA2.new.update('foo').to_s
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].communicate).to receive(:ready?)
        expect(env[:machine].config.ssh).to receive(:username=).with(ssh.username)
        expect(env[:rimu_api].servers).to receive(:reinstall).with(
          id.to_i,
          {
            :instantiation_options=> {
                                      :domain_name=>config.host_name,
                                      :password=>root_passwd,
                                      :distro=>nil,
                                      :control_panel=>nil
                                      },
            :is_just_minimal_init=>nil,
            :vps_parameters=>{
                              :disk_space_mb=>nil,
                              :memory_mb=>nil,
                              :disk_space_2_mb=>nil
                            }
          }
        )
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::Rebuild.new(app, env)
        @action.call(env)
      end
    end

    context 'when vps_to_clone option is set' do
      it 'reinstall the server using instantiation_via_clone_options' do
        vps_clone = 9999
        # env.stub(:interrupted) { false }
        env[:machine].provider_config.stub(:vps_to_clone) { vps_clone }
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].communicate).to receive(:ready?)
        expect(env[:machine].config.ssh).to receive(:username=).with(ssh.username)
        expect(env[:rimu_api].servers).to receive(:reinstall).with(
          id.to_i,
          {
            :instantiation_via_clone_options=> {
                                      :domain_name=>config.host_name,
                                      :vps_order_oid_to_clone => vps_clone,
                                      },
            :is_just_minimal_init=>nil,
            :vps_parameters=>{
                              :disk_space_mb=>nil,
                              :memory_mb=>nil,
                              :disk_space_2_mb=>nil
                            }
          }
        )
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::Rebuild.new(app, env)
        @action.call(env)
      end

      # it 'raise an exception if ssh not ready' do
      #   vps_clone = 9999
      #   env.stub(:interrupted) { nil }
      #   env[:machine].communicate.stub(:ready?) { false }
      #   env[:machine].provider_config.stub(:vps_to_clone) { vps_clone }
      #   expect(env[:machine].provider_config).to receive(:setup?)
      #   expect(env[:machine].communicate).to receive(:ready?)
      #   # expect(env[:machine].config.ssh).to receive(:username=).with(ssh.username)
      #   expect(env[:rimu_api].servers).to receive(:reinstall).with(
      #     id.to_i,
      #     {
      #       :instantiation_via_clone_options=> {
      #                                 :domain_name=>config.host_name,
      #                                 :vps_order_oid_to_clone => vps_clone,
      #                                 },
      #       :is_just_minimal_init=>nil,
      #       :vps_parameters=>{
      #                         :disk_space_mb=>nil,
      #                         :memory_mb=>nil,
      #                         :disk_space_2_mb=>nil
      #                       }
      #     }
      #   )
      #   expect(app).not_to receive(:call)
      #   @action = VagrantPlugins::Rimu::Actions::Rebuild.new(app, env)
      #   lambda { @action.call(env) }.should raise_error
      # end
    end
  end
end
