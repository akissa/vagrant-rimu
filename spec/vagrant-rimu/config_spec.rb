require 'pathname'

require 'spec_helper'

describe VagrantPlugins::Rimu::Config do
  describe 'defaults' do
    let(:vagrant_public_key) { Vagrant.source_root.join('keys/vagrant.pub') }

    subject do
      super().tap(&:finalize!)
    end

    its(:api_key) { should be_nil }
    its(:api_url) { should be_nil }
    its(:distro_code) { should eq("centos6.64") }
    its(:data_centre) { should be_nil }
    its(:disk_space_mb) { should eq(20000) }
    its(:disk_space_2_mb) { should be_nil }
    its(:memory_mb) { should eq(1024) }
    its(:vps_type) { should be_nil }
    its(:host_name) { should be_nil }
    its(:root_password) { should be_nil }
    its(:control_panel) { should be_nil }
    its(:vps_to_clone) { should be_nil }
    its(:extra_ip_reason) { should be_nil }
    its(:num_ips) { should be_nil }
    its(:private_ips) { should be_nil }
    its(:billing_id) { should be_nil }
    its(:host_server_id) { should be_nil }
    its(:minimal_init) { should be_nil }
  end

  describe 'overriding defaults' do
    [
      :api_key,
      :api_url,
      :distro_code,
      :data_centre,
      :disk_space_mb,
      :disk_space_2_mb,
      :memory_mb,
      :vps_type,
      :host_name,
      :root_password,
      :control_panel,
      :vps_to_clone,
      :extra_ip_reason,
      :num_ips,
      :private_ips,
      :billing_id,
      :host_server_id,
      :minimal_init,
    ].each do |attribute|
      it "should not default #{attribute} if overridden" do
        subject.send("#{attribute}=".to_sym, 'foo')
        subject.finalize!
        subject.send(attribute).should == 'foo'
      end
    end
  end

  describe 'validation' do
    let(:machine) { double('machine') }
    let(:validation_errors) { subject.validate(machine)['Rimu Provider'] }
    let(:error_message) { double('error message') }
    let(:config) { double('config') }
    let(:ssh) { double('ssh') }

    before(:each) do
      machine.stub_chain(:env, :root_path).and_return '/'
      ssh.stub(:private_key_path) { File.expand_path('test/test_rimu_id_rsa', Pathname.new(File.expand_path('../../../', __FILE__))) }
      ssh.stub(:username) { 'ssh username' }
      config.stub(:ssh) { ssh }
      machine.stub(:config) { config }
      subject.api_key = 'bar'
      subject.host_name = 'foo.example.com'
    end

    subject do
      super().tap(&:finalize!)
    end

    # context 'with invalid key' do
    #   it 'should raise an error' do
    #     subject.dummy1 = true
    #     subject.dummy2 = false
    #     I18n.should_receive(:t).with('vagrant.config.common.bad_field', fields: 'dummy1, dummy2')
    #     .and_return error_message
    #     validation_errors.first.should == error_message
    #     # validation_errors.should_not be_empty
    #   end
    # end

    context 'the API key' do
      it 'should error if not set' do
        subject.api_key = nil
        I18n.should_receive(:t).with('vagrant_rimu.config.api_key').and_return error_message
        validation_errors.first.should == error_message
      end
    end

    context 'the ssh private key path' do
      it 'should raise an error if not set' do
        ssh.stub(:private_key_path) { nil }
        subject.private_key_path = nil
        I18n.should_receive(:t).with('vagrant_rimu.config.private_key').and_return error_message
        validation_errors.first.should == error_message
      end
      it 'should raise an error if key does not exist' do
        ssh.stub(:private_key_path) { 'missing' }
        I18n.should_receive(:t).with('vagrant_rimu.config.missing_private_key', {:key=>'missing'}).and_return error_message
        validation_errors.first.should == error_message
      end
      it 'should not have errors if the key exists with an absolute path' do
        subject.private_key_path = File.expand_path 'locales/en.yml', Dir.pwd
        validation_errors.should be_empty
      end
      it 'should not have errors if the key exists with a relative path' do
        machine.stub_chain(:env, :root_path).and_return '.'
        subject.private_key_path = 'locales/en.yml'
        validation_errors.should be_empty
      end
    end

    context 'the ssh public key path' do
      it "should raise an error if the key doesn't exist" do
        key = File.expand_path 'locales/en.yml', Dir.pwd
        ssh.stub(:private_key_path) { key }
        I18n.should_receive(:t).with('vagrant_rimu.config.public_key', {:key=>"#{key}.pub"}).and_return error_message
        validation_errors.first.should == error_message
      end
      it 'should not have errors if the key exists with an absolute path' do
        subject.public_key_path = File.expand_path 'locales/en.yml', Dir.pwd
        validation_errors.should be_empty
      end
      it 'should not have errors if the key exists with a relative path' do
        machine.stub_chain(:env, :root_path).and_return '.'
        subject.public_key_path = 'locales/en.yml'
        validation_errors.should be_empty
      end
    end

    context 'the host name' do
      it 'should raise an error if not set' do
        subject.host_name = nil
        I18n.should_receive(:t).with('vagrant_rimu.config.host_name').and_return error_message
        validation_errors.first.should == error_message
      end
      it 'should raise an error if not FQDN' do
        subject.host_name = 'james'
        I18n.should_receive(:t).with('vagrant_rimu.config.invalid_host_name', {:host_name => 'james'}).and_return error_message
        validation_errors.first.should == error_message
      end
    end

    context 'with good values' do
      it 'should validate' do
        validation_errors.should be_empty
      end
    end
  end
end
