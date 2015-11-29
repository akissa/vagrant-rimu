require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::Create do
  let(:dup) { double('dup') }
  let(:ssh) { double('ssh') }
  # let(:action_runner) { double('action_runner') }
  let(:servers) { double('servers') }
  let(:machine) { double('machine') }
  let(:create) { double('create') }
  let(:communicate) { double('communicate') }
  let(:id) { '200' }

  let(:config) do
    double.tap do |config|
      config.stub(:api_url) { nil }
      config.stub(:api_key) { 'foo' }
      config.stub(:host_name) { 'rimu.example.com' }
      config.stub(:root_password) { 'P455w0rd' }
      config.stub(:distro_code) { nil }
      config.stub(:control_panel) { nil }
      config.stub(:vps_to_clone) { nil }
      config.stub(:minimal_init) { nil }
      config.stub(:disk_space_mb) { nil }
      config.stub(:memory_mb) { nil }
      config.stub(:disk_space_2_mb) { nil }
      config.stub(:billing_id) { nil }
      config.stub(:data_centre) { nil }
      config.stub(:host_server_id) { nil }
      config.stub(:extra_ip_reason) { nil }
      config.stub(:num_ips) { nil }
      config.stub(:private_ips) { nil }
      config.stub(:vps_type) { nil }
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
        create.stub(:order_oid) { id }
        create.stub(:allocated_ips) { {:primary_ip => '192.168.1.10'} }
        servers.stub(:create) { create }
        os.stub(:servers) { servers }
      end
      machine.stub(:id) { id }
      machine.stub(:id=) { id }
      env[:machine] = machine
      env[:machine].stub(:config) { config }
      env[:machine].stub(:provider_config) { config }
      communicate.stub(:ready?) { true }
      env[:machine].stub(:communicate) { communicate }
      # dup.stub(:delete) { double('delete') }
      # dup.stub(:[]=) { double('[]=') }
      # env.stub(:dup) { dup }
      # action_runner.stub(:run) { double('run') }
      # env[:action_runner] = action_runner
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
      # app.stub(:terminate).with(anything)
    end
  end

  describe 'call' do
    context 'when vps_to_clone option is not set' do
      it 'should install the server using instantiation_options' do
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].communicate).to receive(:ready?)
        expect(env[:machine].config.ssh).to receive(:username=).with(ssh.username)
        expect(env[:rimu_api].servers).to receive(:create).with(
          {
            :billing_oid => config.billing_id,
            :dc_location => config.data_centre,
            :host_server_oid => config.host_server_id,
            :instantiation_options=> {
                                      :domain_name=>config.host_name,
                                      :password=>config.root_password,
                                      :distro=>config.distro_code,
                                      :control_panel=>config.control_panel
                                      },
            :ip_request => {
                :extra_ip_reason => config.extra_ip_reason,
                :num_ips => config.num_ips,
                :requested_ips => config.private_ips,
            },
            :is_just_minimal_init=>nil,
            :vps_parameters=>{
                              :disk_space_mb=>nil,
                              :memory_mb=>nil,
                              :disk_space_2_mb=>nil
                            },
            :vps_type => config.vps_type,
          }
        )
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::Create.new(app, env)
        @action.call(env)
      end
    end

    context 'when vps_to_clone option is set' do
      it 'should install the server using instantiation_via_clone_options' do
        vps_clone = 9999
        env[:machine].provider_config.stub(:vps_to_clone) { vps_clone }
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].communicate).not_to receive(:ready?)
        expect(env[:machine].config.ssh).to receive(:username=).with(ssh.username)
        expect(env[:rimu_api].servers).to receive(:create).with(
          {
            :billing_oid => config.billing_id,
            :dc_location => config.data_centre,
            :host_server_oid => config.host_server_id,
            :instantiation_via_clone_options=> {
                                      :domain_name=>config.host_name,
                                      :vps_order_oid_to_clone => vps_clone,
                                      },
            :ip_request => {
                :extra_ip_reason => config.extra_ip_reason,
                :num_ips => config.num_ips,
                :requested_ips => config.private_ips,
            },
            :is_just_minimal_init=>nil,
            :vps_parameters=>{
                              :disk_space_mb=>nil,
                              :memory_mb=>nil,
                              :disk_space_2_mb=>nil
                            },
            :vps_type => config.vps_type,
          }
        )
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::Create.new(app, env)
        @action.call(env)
      end
    end
    
    # context 'when terminate is run' do
    #   it 'should call the destroy action' do
    #     expect(app.dup).to receive(:[]=).with(:config_validate, false)
    #     expect(app.dup).to receive(:[]=).with(:force_confirm_destroy, true)
    #     expect(env[:action_runner]).to receive(:run)
    #     expect(app).to receive(:terminate)
    #     @action = VagrantPlugins::Rimu::Actions::Create.new(app, env)
    #     @action.terminate(env)
    #   end
    # end
  end
end
