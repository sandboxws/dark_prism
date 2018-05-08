require 'spec_helper.rb'

class DummyClass
  include DarkPrism::Dispatch
end

RSpec.describe DarkPrism::Dispatch do
  let(:instance) { DummyClass.new }

  describe '#dispatch_event' do
    it 'should invoke dispatch method on the Dispatcher singleton' do
      dispatcher_instance = DarkPrism::Dispatcher.instance
      expect(dispatcher_instance).to receive(:dispatch).once
      instance.dispatch_event('my_event', {})
    end
  end
end
