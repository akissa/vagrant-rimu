require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::ModifyProvisionPath do
  let(:communicate) { double('communicate') }
  let(:sudo) { double('sudo') }
  let(:machine) { double('machine') }
  let(:ssh_info) { double('ssh_info') }
  let(:vm) { double('vm') }
  let(:provisioners) { double('provisioners') }
  
  let(:provisioner) do
    double.tap do |p|
      p.stub(:config) {{:upload_path => '/tmp'}}
    end
  end
  
  let(:config) do
    double.tap do |config|
      provisioners.stub(:each).and_yield(provisioner).and_yield(provisioner)
      vm.stub(:provisioners) { provisioners }
      config.stub(:vm) { vm }
    end
  end

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      communicate.stub(:sudo) { sudo }
      machine.stub(:config) { config }
      ssh_info.stub(:[]) { {:username=>'rimu'} }
      machine.stub(:ssh_info) { ssh_info }
      machine.stub(:communicate) { communicate }
      env[:machine] = machine
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    context 'when provisioning is not enabled' do
      it 'should not call provisioners' do
        env.stub(:has_key?).with(:provision_enabled) { true }
        expect(env).to receive(:has_key?).with(:provision_enabled)
        expect(env[:machine]).not_to receive(:ssh_info)
        expect(env[:machine].config.vm.provisioners).not_to receive(:each)
        expect(env[:machine].communicate).not_to receive(:sudo)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::ModifyProvisionPath.new(app, env)
        @action.call(env)
      end
    end
    
    context 'when provisioning is enabled' do
      it 'should call provisioners' do
        env.stub(:has_key?).with(:provision_enabled) { false }
        expect(env).to receive(:has_key?).with(:provision_enabled)
        expect(env[:machine]).to receive(:ssh_info)
        expect(env[:machine].config.vm.provisioners).to receive(:each)
        expect(env[:machine].communicate).to receive(:sudo)
        @action = VagrantPlugins::Rimu::Actions::ModifyProvisionPath.new(app, env)
        @action.call(env)
      end
    end
  end
end
