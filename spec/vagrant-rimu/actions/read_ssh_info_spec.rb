require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::ReadSSHInfo do
  let(:ssh) { double('ssh') }
  let(:orders) { double('orders') }
  let(:machine) { double('machine') }
  let(:order) { double('order') }
  let(:allocated_ips) { {:primary_ip=>'192.168.1.1'} }
  let(:id) { '200' }

  let(:config) do
    double.tap do |config|
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
        order.stub(:allocated_ips) { allocated_ips }
        orders.stub(:order) { order }
        os.stub(:orders) { orders }
      end
      machine.stub(:id) { id }
      machine.stub(:config) { config }
      env[:machine] = machine
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    context 'when machine id is nil' do
      it 'should not call order' do
        env[:machine].id.stub(:nil?) { true }
        expect(env[:machine].id).to receive(:nil?)
        expect(order).not_to receive(:allocated_ips)
        expect(env[:rimu_api].orders).not_to receive(:order).with(id.to_i)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::ReadSSHInfo.new(app, env)
        @action.call(env)
      end
    end
    
    context 'when machine id is not nil' do
      it 'should call orders' do
        env[:machine].id.stub(:nil?) { false }
        expect(env[:machine].id).to receive(:nil?)
        expect(order).to receive(:allocated_ips)
        expect(env[:rimu_api].orders).to receive(:order).with(id.to_i)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::ReadSSHInfo.new(app, env)
        @action.call(env)
      end
    end
    
    context 'when api call returns nil' do
      it 'should return nil machine id' do
        env[:machine].id.stub(:nil?) { false }
        expect(env[:machine].id).to receive(:nil?)
        expect(order).not_to receive(:allocated_ips)
        expect(env[:rimu_api].orders).to receive(:order).with(id.to_i).and_return(nil)
        expect(env[:machine]).to receive(:id=).with(nil)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::ReadSSHInfo.new(app, env)
        @action.call(env)
      end
    end
  end
end
