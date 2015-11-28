require 'spec_helper'

describe VagrantPlugins::Rimu::Commands::Distributions do
  let(:machine) { double('machine') }

  let(:env) do
    {}.tap do |env|
      machine.stub(:action).with('list_distributions') { 1 }
      env[:machine] = machine
    end
  end
  
  before :each do
    @list_distributions_cmd = VagrantPlugins::Rimu::Commands::Distributions.new(nil, env)
  end
  
  it 'calls the machine list_distributions action' do
    env[:machine].should_receive(:action).with('list_distributions')
    @list_distributions_cmd.cmd('distributions', [], env)
  end
end
