require 'spec_helper.rb'

class DummyClass
  include DarkPrism::Dispatch
end

RSpec.describe DarkPrism::Dispatch do
  let(:instance) { DummyClass.new }

  describe '#dispatch_event' do
    it 'invokes dispatch method on the Dispatcher singleton' do
      dispatcher_instance = DarkPrism::Dispatcher.instance
      expect(dispatcher_instance).to receive(:dispatch).once
      instance.dispatch_event('my_event', {})
    end
  end

  describe '#dispatch_pubsub' do
    it 'invokes dispatch_pubsub method on the Dispatcher singleton' do
      dispatcher_instance = DarkPrism::Dispatcher.instance
      expect(dispatcher_instance).to receive(:dispatch_pubsub).once
      instance.dispatch_pubsub('my_event', instance)
    end
  end

  describe '#dispatch_pubsub_async' do
    it 'invokes dispatch_pubsub_async method on the Dispatcher singleton' do
      dispatcher_instance = DarkPrism::Dispatcher.instance
      expect(dispatcher_instance).to receive(:dispatch_pubsub_async).once
      instance.dispatch_pubsub_async('my_event', instance)
    end
  end
end
