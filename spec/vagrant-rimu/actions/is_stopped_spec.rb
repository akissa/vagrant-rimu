require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::IsStopped do
  let(:state) { double('state') }
  let(:machine) { double('machine') }

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      machine.stub(:state) { state }
      env[:machine] = machine
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    context 'when server is stopped' do
      it 'returns true' do
        env[:machine].state.stub(:id) { :stopped }
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::IsStopped.new(app, env)
        @action.call(env)
        env[:result].should == true
      end
    end
    
    context 'when server is running' do
      it 'returns false' do
        env[:machine].state.stub(:id) { :running }
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::IsStopped.new(app, env)
        @action.call(env)
        env[:result].should == false
      end
    end
  end
end
