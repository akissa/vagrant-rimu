require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::SetupSudo do
  let(:ssh) { double('ssh') }
  let(:guest) { double('guest') }
  let(:machine) { double('machine') }
  let(:execute) { double('execute') }
  let(:communicate) { double('communicate') }

  let(:config) do
    double.tap do |config|
      config.stub(:api_url) { nil }
      config.stub(:api_key) { 'foo' }
      ssh.stub(:username) { 'rimu' }
      ssh.stub(:username=) { 'rimu' }
      ssh.stub(:private_key_path) { 'test/test_rimu_id_rsa' }
      config.stub(:ssh) { ssh }
    end
  end

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      communicate.stub(:execute) { execute }
      env[:machine] = machine
      guest.stub(:name) { 'redhat' }
      guest.stub(:respond_to?).with(:name) { true }
      env[:machine].stub(:guest) { guest }
      env[:machine].stub(:config) { config }
      env[:machine].stub(:communicate) { communicate }
      env[:machine].stub(:provider_config) { config }
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    user = 'rimu'
    context 'when guest name is set to redhat' do
      it 'setup sudo' do
        env[:machine].provider_config.stub(:setup?) { true }
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].config.ssh).to receive(:username=).with('root')
        expect(env[:machine].guest).to receive(:respond_to?).with(:name)
        expect(env[:machine].communicate).to receive(:execute)
        expect(env[:machine].config.ssh).to receive(:username=).with(user)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::SetupSudo.new(app, env)
        @action.call(env)
      end
    end

    context 'when guest name is not set to redhat' do
      it 'do nothing' do
        env[:machine].provider_config.stub(:setup?) { true }
        env[:machine].guest.stub(:name) { 'debian' }
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].config.ssh).to receive(:username=).with('root')
        expect(env[:machine].guest).to receive(:respond_to?).with(:name)
        expect(env[:machine].communicate).not_to receive(:execute)
        expect(env[:machine].config.ssh).to receive(:username=).with(user)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::SetupSudo.new(app, env)
        @action.call(env)
      end
    end

    context 'when setup is not enabled' do
      it 'do nothing' do
        env[:machine].provider_config.stub(:setup?) { false }
        env[:machine].guest.stub(:name) { 'debian' }
        expect(env[:machine].provider_config).to receive(:setup?)
        expect(env[:machine].config.ssh).not_to receive(:username=).with('root')
        expect(env[:machine].guest).not_to receive(:respond_to?).with(:name)
        expect(env[:machine].communicate).not_to receive(:execute)
        expect(env[:machine].config.ssh).not_to receive(:username=).with(user)
        expect(app).to receive(:call)
        @action = VagrantPlugins::Rimu::Actions::SetupSudo.new(app, env)
        @action.call(env)
      end
    end
  end
end
