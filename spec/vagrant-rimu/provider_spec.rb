require 'spec_helper'

describe VagrantPlugins::Rimu::Provider do
  before :each do
    @provider = VagrantPlugins::Rimu::Provider.new :machine
  end

  describe 'to string' do
    it 'should give the provider name with new id' do
      @provider.to_s.should eq('Rimu (new)')
    end
  end
end
