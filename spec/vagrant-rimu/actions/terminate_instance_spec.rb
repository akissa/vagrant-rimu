require 'ostruct'
require 'pathname'

require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::TerminateInstance do
  let(:servers) { double('servers') }
  let(:cancel) { double('cancel') }

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        servers.stub(:cancel) { cancel }
        os.stub(:servers) { servers }
      end
      env[:machine] = OpenStruct.new
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    context 'when server id is set' do
      it 'terminates the server' do
        id = '200'
        env[:machine].id = id
        expect(env[:rimu_api].servers).to receive(:cancel).with(id.to_i)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::TerminateInstance.new(app, env)
        @action.call(env)
      end
    end
    context 'when server id is not set' do
      it 'do nothing' do
        env[:machine].id = nil
        expect(env[:rimu_api].servers).to_not receive(:cancel)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::TerminateInstance.new(app, env)
        @action.call(env)
      end
    end
  end
end
