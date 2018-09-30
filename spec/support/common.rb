require 'spec_helper'

class SampleListeners
  def self.listeners
    {
      some_event: [SampleListener.new]
    }.freeze
  end
end

class SampleListener
  def some_event(data); end
end

class SomeObject
  def to_pubsub
    { foo: :bar }.to_json
  end
end
