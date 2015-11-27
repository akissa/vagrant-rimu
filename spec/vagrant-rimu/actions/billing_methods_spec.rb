require 'ostruct'
require 'pathname'

require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::BillingMethods do
  let(:billing_methods) { double('billing_methods') }
  let(:machine) { double('machine') }
  let(:method1) { OpenStruct.new({:billing_oid => 1012, :billing_method_type => 'TS_WIRE', :description => 'Wire Transfer'}) }
  let(:method2) { OpenStruct.new({:billing_oid => 2000, :billing_method_type => 'TS_CARD', :description => 'Credit Card'}) }


  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        billing_methods.stub(:each).and_yield(method1).and_yield(method2)
        os.stub(:billing_methods) { billing_methods }
      end
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    it 'return a billing_methods listing' do
      expect(env[:rimu_api].billing_methods).to receive(:each)
      heading = '%-6s %-6s %s' % ['ID', 'Type', 'Description']
      expect(env[:ui]).to receive(:info).with(heading)
      [method1, method2].each do |b|
        row = '%-6s %-6s %s' % [b.billing_oid, b.billing_method_type, b.description]
        expect(env[:ui]).to receive(:info).with(row)
      end
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::BillingMethods.new(app, env)
      @action.call(env)
    end
  end
end
