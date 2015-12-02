require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::StopInstance do
  let(:servers) { double('servers') }
  let(:shutdown) { double('shutdown') }
  let(:machine) { double('machine') }
  let(:state) { double('state') }
  let(:id) { '200' }

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        servers.stub(:shutdown) { shutdown }
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
    context 'when server state id is not :off' do
      it 'stops the server' do
        state.stub(:id) { :active }
        env[:machine].stub(:state) { state }
        expect(env[:rimu_api].servers).to receive(:shutdown).with(id.to_i)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::StopInstance.new(app, env)
        @action.call(env)
      end
    end
    context 'when server id is :off' do
      it 'does nothing' do
        state.stub(:id) { :off }
        env[:machine].stub(:state) { state }
        expect(env[:rimu_api].servers).to_not receive(:shutdown)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::StopInstance.new(app, env)
        @action.call(env)
      end
    end
  end
end
