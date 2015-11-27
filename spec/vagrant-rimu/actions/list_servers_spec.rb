require 'pathname'
require 'spec_helper'

# action_root = Pathname.new(File.expand_path('../../../../lib/vagrant-rimu/actions', __FILE__))
# autoload :StopInstance, action_root.join('stop_instance')

describe VagrantPlugins::Rimu::Actions::ListServers do
  let(:orders) { double('orders') }
  let(:ordersm) { double('ordersm') }
  let(:machine) { double('machine') }
  let(:server1) { OpenStruct.new({:order_oid => 1, :domain_name => 'rimu01.example.com', :location => {:data_center_location_code => 'DCDALLAS'}, :host_server_oid => 200, :running_state => 'RUNNING'}) }
  let(:server2) { OpenStruct.new({:order_oid => 2, :domain_name => 'rimu02.example.com', :location => {:data_center_location_code => 'DCDALLAS'}, :host_server_oid => 200, :running_state => 'NOTRUNNING'}) }


  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui').tap do |ui|
        ui.stub(:info).with(anything)
        ui.stub(:error).with(anything)
      end
      env[:rimu_api] = double('rimu_api').tap do |os|
        orders.stub(:each).and_yield(server1).and_yield(server2)
        ordersm.stub(:orders) { orders }
        os.stub(:orders) { ordersm }
      end
    end
  end

  let(:app) do
    double('app').tap do |app|
      app.stub(:call).with(anything)
    end
  end

  describe 'call' do
    it 'return a server listing' do
      expect(env[:rimu_api].orders.orders).to receive(:each)
      heading = '%-8s %-20s %-20s %-15s %-15s' % ['ID', 'Hostname', 'Data Centre', 'Host Server', 'Status']
      expect(env[:ui]).to receive(:info).with(heading)
      [server1, server2].each do |o|
        row = '%-8s %-20s %-20s %-15s %-15s' % [o.order_oid, o.domain_name, o.location["data_center_location_code"], o.host_server_oid, o.running_state]
        expect(env[:ui]).to receive(:info).with(row)
      end
      expect(app).to receive(:call)
      @action = VagrantPlugins::Rimu::Actions::ListServers.new(app, env)
      @action.call(env)
    end
  end
end
