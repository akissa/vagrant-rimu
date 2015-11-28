require 'spec_helper'

describe VagrantPlugins::Rimu::Commands::Move do
  let(:machine) { double('machine') }

  let(:env) do
    {}.tap do |env|
      machine.stub(:action).with('move') { 1 }
      env[:machine] = machine
    end
  end
  
  before :each do
    @move_cmd = VagrantPlugins::Rimu::Commands::Move.new(nil, env)
  end
  
  it 'calls the machine move action' do
    env[:machine].should_receive(:action).with('move')
    @move_cmd.cmd('move-vps', [], env)
  end
end
