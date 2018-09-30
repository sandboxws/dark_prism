require "spec_helper.rb"

RSpec.describe DarkPrism::Dispatcher do
  let(:dispatcher) { DarkPrism::Dispatcher.instance }

  it "initializes required data" do
    expect(dispatcher.listeners).to be_a(Hash)
  end

  describe "#dispatch" do
    before do
      dispatcher.clear_all_listeners
      dispatcher.add_listener :some_event, SampleListener.new
    end

    it "returns nil if the dispatched event have no registered listeners" do
      expect(dispatcher.dispatch("no_event", {})).to be_nil
    end

    it "dispatches the event to all listeners" do
      event_data = { some: :data }
      a_listener = dispatcher.listeners[:some_event].first

      expect(a_listener).to receive(:some_event).with(event_data).once
      dispatcher.dispatch :some_event, event_data
    end
  end

  describe "#dispatch_pubsub" do
    before do
      @obj = SomeObject.new
    end

    it "returns nil if the event object does not respond to to_pubsub" do
      expect(dispatcher.dispatch_pubsub(:some_event, "some string")).to be_nil
    end

    it "raises an exception if the topic is not found" do
      topic = instance_double(Google::Cloud::Pubsub::Topic)
      allow(DarkPrism::Config::GcloudConfig.instance.pubsub).to receive(:topic).and_return(nil)

      expect { dispatcher.dispatch_pubsub(:some_event, @obj) }.to raise_error(ArgumentError)
    end

    it "publishes a new pubsub message" do
      topic = instance_double(Google::Cloud::Pubsub::Topic)
      msg = instance_double(Google::Cloud::Pubsub::Message)
      allow(DarkPrism::Config::GcloudConfig.instance.pubsub).to receive(:topic).and_return(topic)
      allow(topic).to receive(:publish).and_return(msg)

      expect(@obj).to receive(:to_pubsub).and_return({ foo: :bar }.to_json)
      expect(dispatcher.dispatch_pubsub(:some_event, @obj)).to be(msg)
    end
  end

  describe "#dispatch_pubsub_async" do
    before do
      @obj = SomeObject.new
    end

    it "returns nil if the event object does not respond to to_pubsub" do
      expect(dispatcher.dispatch_pubsub_async(:some_event, "some string")).to be_nil
    end

    it "raises an exception if the topic is not found" do
      topic = instance_double(Google::Cloud::Pubsub::Topic)
      allow(DarkPrism::Config::GcloudConfig.instance.pubsub).to receive(:topic).and_return(nil)

      expect { dispatcher.dispatch_pubsub_async(:some_event, @obj) }.to raise_error(ArgumentError)
    end

    it "publishes a new pubsub message" do
      topic = instance_double(Google::Cloud::Pubsub::Topic)
      msg = instance_double(Google::Cloud::Pubsub::Message)
      allow(DarkPrism::Config::GcloudConfig.instance.pubsub).to receive(:topic).and_return(topic)
      allow(topic).to receive(:publish_async).and_return(msg)

      expect(@obj).to receive(:to_pubsub).and_return({ foo: :bar }.to_json)
      expect(dispatcher.dispatch_pubsub_async(:some_event, @obj)).to be(msg)
    end
  end

  describe "#add_listener" do
    before do
      dispatcher.clear_all_listeners
    end

    it "associates the listener with the passed event name" do
      dispatcher.add_listener :some_event, SampleListener.new
      expect(dispatcher.listeners.dig(:some_event)).not_to be nil
      expect(dispatcher.listeners.dig(:some_event).size).to eq 1
    end

    it "does not associate the same listener twice" do
      dispatcher.add_listener :some_event, SampleListener.new
      dispatcher.add_listener :some_event, SampleListener.new
      dispatcher.add_listener :some_event, SampleListener.new
      expect(dispatcher.listeners.dig(:some_event)).not_to be nil
      expect(dispatcher.listeners.dig(:some_event).size).to eq 1
    end

    it "raises an exception when listener cannot respond to the event" do
      expect {
        dispatcher.add_listener(:foobar, SampleListener.new)
      }.to raise_error(ArgumentError)
    end
  end

  describe "#remove_listener" do
    it "should be able to remove a listener" do
      listener = SampleListener.new
      dispatcher.add_listener :some_event, listener
      dispatcher.remove_listener :some_event, listener
      expect(dispatcher.listeners[:some_event].size).to eq 0
    end
  end

  describe "#clear_all_listeners" do
    it "should clear all listeners for all events" do
      dispatcher.add_listener :some_event, SampleListener.new
      expect(dispatcher.listeners.size).to be > 0
      dispatcher.clear_all_listeners
      expect(dispatcher.listeners.size).to eq 0
    end
  end
end
