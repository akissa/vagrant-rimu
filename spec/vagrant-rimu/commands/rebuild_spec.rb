require 'spec_helper'

describe VagrantPlugins::Rimu::Commands::Rebuild do
  let(:machine) { double('machine') }

  let(:env) do
    {}.tap do |env|
      machine.stub(:action).with('rebuild') { 1 }
      env[:machine] = machine
    end
  end
  
  before :each do
    @rebuild_cmd = VagrantPlugins::Rimu::Commands::Rebuild.new(nil, env)
  end
  
  it 'calls the machine rebuild action' do
    env[:machine].should_receive(:action).with('rebuild')
    @rebuild_cmd.cmd('rebuild', [], env)
  end
end
