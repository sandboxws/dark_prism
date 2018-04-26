RSpec.describe DarkPrism::Config do
  it 'should return a Config instance' do
    expect(DarkPrism::Config.instance).to be_a(DarkPrism::Config)
  end

  it 'should be a singleton' do
    expect(DarkPrism::Config.instance).to eq(DarkPrism::Config.instance)
  end

  it 'should intialize an instance of DarkPrism::Dispatcher' do
    expect(DarkPrism::Config.instance).not_to be nil
    expect(DarkPrism::Config.instance.dispatcher).to be_a(DarkPrism::Dispatcher)
  end

  describe '.configure' do
    # it 'should raise an exception if a block is not given' do
    #   expect(DarkPrism::Config.configure()).to raise_exception(DarkPrism::NoBlockGivenException)
    # end

    it 'should invoke instance methods when passed a block' do
      expect(DarkPrism::Config.instance).to receive(:register_listeners).with(SampleListeners).once
      DarkPrism::Config.configure do |config|
        config.register_listeners(SampleListeners)
      end
    end
  end
end
