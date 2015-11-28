require 'spec_helper'

describe VagrantPlugins::Rimu::Commands::BillingMethods do
  let(:machine) { double('machine') }

  let(:env) do
    {}.tap do |env|
      machine.stub(:action).with('billing_methods') { 1 }
      env[:machine] = machine
    end
  end
  
  before :each do
    @billing_methods_cmd = VagrantPlugins::Rimu::Commands::BillingMethods.new(nil, env)
  end
  
  it 'calls the machine billing_methods action' do
    env[:machine].should_receive(:action).with('billing_methods')
    @billing_methods_cmd.cmd('billing-methods', [], env)
  end
end
