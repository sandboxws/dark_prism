require 'spec_helper.rb'

RSpec.describe DarkPrism do
  it 'has a version number' do
    expect(DarkPrism::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'returns an instance of DarkPrism::Config::MainConfig' do
      instance = DarkPrism.configure do |config|
        config.register_listeners(SampleListeners)
      end
      expect(instance).to be_a(DarkPrism::Config::MainConfig)
    end

    it 'raises an exception when no block is given' do
      expect { DarkPrism::configure }.to raise_error(DarkPrism::NoBlockGivenException)
    end
  end
end
