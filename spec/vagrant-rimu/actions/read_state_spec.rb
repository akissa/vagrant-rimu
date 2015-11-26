require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::ReadState do
  let(:servers) { double('servers') }
  let(:machine) { double('machine') }
  let(:status) { double('status') }
  let(:id) { '200' }


  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        status.stub(:running_state) { 'RUNNING' }
        servers.stub(:status) { status }
        os.stub(:servers) { servers }
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
    it 'should not call status' do
      env[:machine].id.stub(:nil?) { true }
      expect(env[:machine].id).to receive(:nil?)
      expect(env[:rimu_api].servers).not_to receive(:status).with(id.to_i)
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::ReadState.new(app, env)
      @action.call(env)
    end
    
    it 'should call status' do
      env[:machine].id.stub(:nil?) { false }
      expect(env[:machine].id).to receive(:nil?)
      expect(env[:rimu_api].servers).to receive(:status).with(id.to_i)
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::ReadState.new(app, env)
      @action.call(env)
    end
  end
end
