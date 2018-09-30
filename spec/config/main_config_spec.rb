require 'spec_helper'

RSpec.describe DarkPrism::Config::MainConfig do
  let(:instance) { DarkPrism::Config::MainConfig.instance }

  it 'returns a Config instance' do
    expect(instance)
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
    expect(instance)
      .to eq(instance)
  end

  it 'initializes an instance of DarkPrism::Dispatcher' do
    expect(DarkPrism).not_to be nil
    expect(instance.dispatcher)
      .to be_a(DarkPrism::Dispatcher)
  end

  describe '.configure' do
    it 'invokes instance methods when passed a block' do
      expect(instance)
        .to receive(:register_listeners).with(SampleListeners).once

      DarkPrism::Config::MainConfig.configure do |config|
        config.register_listeners(SampleListeners)
      end
    end
  end

  describe 'remove_logger!' do
    it 'sets the logger to nil' do
      instance.send :remove_logger!
      expect(instance.logger).to be_nil
      instance.logger = Logger.new(STDOUT)
    end
  end

  describe 'logger' do
    it 'uses a STDOUT logger by default' do
      expect(instance.logger.class).to eq(Logger)
    end

    it 'uses Rails.logger if defined' do
      class Rails
        @logger = nil

        class << self
          attr_accessor :logger
        end
      end

      logger = Logger.new(STDOUT)
      Rails.logger = logger

      instance.send :remove_logger!
      instance.send(:init_logger)
      expect(instance.logger).to eq(logger)
      Object.send :remove_const, :Rails
    end
  end

  describe 'sentry' do
    it 'does disables sentry by default' do
      expect(instance.enable_sentry).to be_falsey
    end

    it 'enables sentry' do
      instance.send :enable_sentry=, true
      expect(instance.enable_sentry).to be_truthy
    end
  end
end
