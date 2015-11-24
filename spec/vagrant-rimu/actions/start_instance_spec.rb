require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StartInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::StartInstance do
  let(:servers) { double('servers') }
  let(:start) { double('start') }
  let(:machine) { double('machine') }
  let(:id) { '200' }

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      machine.stub(:id) { id }
      env[:machine] = machine
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    it 'starts server' do
      env[:rimu_api] = double('rimu_api').tap do |os|
        start.stub(:running_state) { 'RUNNING' }
        servers.stub(:start) { start }
        os.stub(:servers) { servers }
      end
      expect(env[:rimu_api].servers).to receive(:start).with(id.to_i)
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::StartInstance.new(app, env)
      @action.call(env)
    end

    it 'raises exception if api does not respond' do
      env[:rimu_api] = double('rimu_api').tap do |os|
        servers.stub(:start) { nil }
        os.stub(:servers) { servers }
      end
      expect(env[:rimu_api].servers).to receive(:start).with(id.to_i)
      @action = VagrantPlugins::Rimu::Actions::StartInstance.new(app, env)
      lambda { @action.call(env) }.should raise_error(VagrantPlugins::Rimu::Errors::ApiError)
    end

    it 'raises exception if server does not start' do
      env[:rimu_api] = double('rimu_api').tap do |os|
        start.stub(:running_state) { 'NOTRUNNING' }
        servers.stub(:start) { start }
        os.stub(:servers) { servers }
      end
      expect(env[:rimu_api].servers).to receive(:start).with(id.to_i)
      @action = VagrantPlugins::Rimu::Actions::StartInstance.new(app, env)
      lambda { @action.call(env) }.should raise_error(VagrantPlugins::Rimu::Errors::ApiError)
    end
  end
end
