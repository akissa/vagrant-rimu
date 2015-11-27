require 'ostruct'
require 'pathname'

require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::MessageWillNotDestroy do  
  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
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
    it 'sets info variable' do
      name = 'rimu.example.com'
      env[:machine].name = name
      expect(I18n).to receive(:t).with('vagrant_rimu.will_not_destroy', {:name => name})
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::MessageWillNotDestroy.new(app, env)
      @action.call(env)
    end
  end
end