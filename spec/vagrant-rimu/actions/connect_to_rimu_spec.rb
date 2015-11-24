require 'spec_helper'

describe VagrantPlugins::Rimu::Actions::ConnectToRimu do
  let(:app) do
    double.tap do |app|
      app.stub(:call)
    end
  end

  let(:config) do
    double.tap do |config|
      config.stub(:api_url) { nil }
      config.stub(:api_key) { 'foo' }
    end
  end

  let(:env) do
    {}.tap do |env|
      env[:ui] = double
      env[:ui].stub(:info).with(anything)
      env[:ui].stub(:warn).with(anything)
      env[:machine] = double('machine')
      env[:machine].stub(:provider_config) { config }
      env[:rimu_api] = double('rimu_api')
    end
  end

  before :each do
    @action = VagrantPlugins::Rimu::Actions::ConnectToRimu.new(app, env)
  end

  describe 'ConnectToRimu' do
    it 'set the correct api_key' do
      @action.call(env)
      expect(env[:rimu_api].api_key).to eq('foo')
    end
  end
end
