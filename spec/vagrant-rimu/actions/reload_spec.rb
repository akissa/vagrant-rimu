require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::Reload do
  let(:servers) { double('servers') }
  let(:reboot) { double('reboot') }
  let(:machine) { double('machine') }
  let(:id) { '200' }

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        servers.stub(:reboot) { reboot }
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
    it 'restarts the server' do
      expect(env[:rimu_api].servers).to receive(:reboot).with(id.to_i)
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::Reload.new(app, env)
      @action.call(env)
    end
  end
end
