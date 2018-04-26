require 'spec_helper.rb'

RSpec.describe DarkPrism::Dispatcher do
  let(:dispatcher) { DarkPrism::Dispatcher.instance }

  it 'should inistialize require data' do
    expect(dispatcher.listeners).to be_a(Hash)
  end

  describe '#dispatch' do
    before do
      dispatcher.clear_all_listeners
      dispatcher.add_listener :some_event, SampleListener.new
    end

    it 'should dispatch event to all listeners' do
      event_data = {some: :data}
      expect(dispatcher.listeners[:some_event].first).to receive(:some_event).with(event_data).once
      dispatcher.dispatch :some_event, event_data
    end
  end

  describe '#add_listener' do
    before do
      dispatcher.clear_all_listeners
    end

    it 'should associate the listener with the passed event name' do
      dispatcher.add_listener :some_event, SampleListener.new
      expect(dispatcher.listeners.dig(:some_event)).not_to be nil
      expect(dispatcher.listeners.dig(:some_event).size).to eq 1
    end

    it 'should not associate the same listener with the same event more than once' do
      listener = SampleListener.new
      dispatcher.add_listener :some_event, listener
      dispatcher.add_listener :some_event, listener
      dispatcher.add_listener :some_event, listener
      expect(dispatcher.listeners.dig(:some_event)).not_to be nil
      expect(dispatcher.listeners.dig(:some_event).size).to eq 1
    end

    it 'should raise an exception if the listener cannot respond to the passed event' do
      expect {
        dispatcher.add_listener(:foobar, SampleListener.new)
      }.to raise_error(ArgumentError)
    end
  end

  describe '#remove_listener' do
    it 'should be able to remove a listener' do
      listener = SampleListener.new
      dispatcher.add_listener :some_event, listener
      dispatcher.remove_listener :some_event, listener
      expect(dispatcher.listeners[:some_event].size).to eq 0
    end
  end

  describe '#clear_all_listeners' do
    it 'should clear all listeners for all events' do
      dispatcher.add_listener :some_event, SampleListener.new
      expect(dispatcher.listeners.size).to be > 0
      dispatcher.clear_all_listeners
      expect(dispatcher.listeners.size).to eq 0
    end
  end
end
