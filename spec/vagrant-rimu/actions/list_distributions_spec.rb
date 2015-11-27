require 'ostruct'
require 'pathname'

require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::ListDistributions do
  let(:distributions) { double('distributions') }
  let(:machine) { double('machine') }
  let(:distro1) { OpenStruct.new({:distro_code => 'jessie.64', :distro_description => 'Debian 8.0 64-bit (aka Jessie, RimuHosting recommended distro)'}) }
  let(:distro2) { OpenStruct.new({:distro_code => 'centos6.64', :distro_description => 'Centos6 64-bit'}) }


  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        distributions.stub(:each).and_yield(distro1).and_yield(distro2)
        os.stub(:distributions) { distributions }
      end
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    it 'return a distribution listing' do
      expect(env[:rimu_api].distributions).to receive(:each)
      heading = '%-6s %s' % ['Distro Code', 'Distro Description']
      expect(env[:ui]).to receive(:info).with(heading)
      [distro1, distro2].each do |o|
        row = '%-6s %s' % [o.distro_code, o.distro_description]
        expect(env[:ui]).to receive(:info).with(row)
      end
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::ListDistributions.new(app, env)
      @action.call(env)
    end
  end
end
