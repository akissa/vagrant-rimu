require 'ostruct'
require 'pathname'

require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::MessageAlreadyCreated do  
  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    it 'sets info variable' do
      expect(I18n).to receive(:t).with('vagrant_rimu.already_status', :status => 'created')
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::MessageAlreadyCreated.new(app, env)
      @action.call(env)
    end
  end
end