require 'spec_helper'

describe VagrantPlugins::Rimu::Commands::ListServers do
  let(:machine) { double('machine') }

  let(:env) do
    {}.tap do |env|
      machine.stub(:action).with('list_servers') { 1 }
      env[:machine] = machine
    end
  end
  
  before :each do
    @list_servers_cmd = VagrantPlugins::Rimu::Commands::ListServers.new(nil, env)
  end
  
  it 'calls the machine list_servers action' do
    env[:machine].should_receive(:action).with('list_servers')
    @list_servers_cmd.cmd('servers', [], env)
  end
end
