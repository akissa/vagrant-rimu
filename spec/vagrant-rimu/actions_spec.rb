require 'spec_helper'

describe VagrantPlugins::Rimu::Actions do
  let(:builder) do
    double('builder').tap do |builder|
      builder.stub(:use)
    end
  end

  # before :each do
  #   Actions.stub(:new_builder) { builder }
  # end
  #
  # describe 'action_destroy' do
  #   it 'add others middleware to builder' do
  #     expect(builder).to receive(:use).with(ConfigValidate)
  #     expect(builder).to receive(:use).with(ConnectToRimu)
  #     expect(builder).to receive(:use).with(Call, ReadState)
  #     Actions.action_destroy
  #   end
  # end
end
