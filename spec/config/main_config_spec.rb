require 'spec_helper'

RSpec.describe DarkPrism::Config::MainConfig do
  it 'returns a Config instance' do
    expect(DarkPrism::Config::MainConfig.instance)
      .to be_a(DarkPrism::Config::MainConfig)
  end

  it 'returns a GcloudConfig instance' do
    expect(Google::Cloud::Pubsub).to receive(:new).with({ project: 'project_id', keyfile: 'credentials' }).and_return(true)
    expect(
      DarkPrism::Config::MainConfig.instance.gcloud do |c|
        c.project_id = 'project_id'
        c.credentials = 'credentials'
      end
    )
      .to be_a(DarkPrism::Config::GcloudConfig)
  end

  it 'returns a singleton' do
    expect(DarkPrism::Config::MainConfig.instance)
      .to eq(DarkPrism::Config::MainConfig.instance)
  end

  it 'initializes an instance of DarkPrism::Dispatcher' do
    expect(DarkPrism::Config::MainConfig.instance).not_to be nil
    expect(DarkPrism::Config::MainConfig.instance.dispatcher)
      .to be_a(DarkPrism::Dispatcher)
  end

  describe '.configure' do
    it 'invokes instance methods when passed a block' do
      expect(DarkPrism::Config::MainConfig.instance)
        .to receive(:register_listeners).with(SampleListeners).once

      DarkPrism::Config::MainConfig.configure do |config|
        config.register_listeners(SampleListeners)
      end
    end
  end
end
