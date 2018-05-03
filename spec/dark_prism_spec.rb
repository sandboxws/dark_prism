require 'spec_helper.rb'

RSpec.describe DarkPrism do
  it 'has a version number' do
    expect(DarkPrism::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'should return an instance of DarkPrism::Config' do
      instance = DarkPrism.configure do |config|
        config.register_listeners(SampleListeners)
      end
      expect(instance).to be_a(DarkPrism::Config)
    end
  end
end
