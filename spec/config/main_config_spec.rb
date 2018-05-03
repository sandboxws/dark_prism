require 'spec_helper'

RSpec.describe DarkPrism::Config::MainConfig do
  it 'should return a Config instance' do
    expect(DarkPrism::Config::MainConfig.instance).to be_a(DarkPrism::Config::MainConfig)
  end

  it 'should be a singleton' do
    expect(DarkPrism::Config::MainConfig.instance).to eq(DarkPrism::Config::MainConfig.instance)
  end

  it 'should intialize an instance of DarkPrism::Dispatcher' do
    expect(DarkPrism::Config::MainConfig.instance).not_to be nil
    expect(DarkPrism::Config::MainConfig.instance.dispatcher).to be_a(DarkPrism::Dispatcher)
  end

  describe '.configure' do
    it 'should invoke instance methods when passed a block' do
      expect(DarkPrism::Config::MainConfig.instance).to receive(:register_listeners).with(SampleListeners).once
      DarkPrism::Config::MainConfig.configure do |config|
        config.register_listeners(SampleListeners)
      end
    end
  end
end
