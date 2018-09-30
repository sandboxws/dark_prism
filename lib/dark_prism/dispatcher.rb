module DarkPrism
  class Dispatcher
    include Singleton
    attr_reader :listeners

    def initialize
      @listeners = {}.with_indifferent_access
    end

    def dispatch(event_name, obj)
      return unless @listeners.include?(event_name)

      @listeners.dig(event_name).each do |listener|
        listener.send(event_name, obj)
      end

      true
    end

    def dispatch_pubsub(topic_name, obj, attributes = nil)
      return unless obj.respond_to? :to_pubsub

      message = obj.to_pubsub
      topic = pubsub.topic topic_name
      unless topic.present?
        raise 'Topic not found. Please create the pubsub topic and try again'
      end

      topic.publish message, attributes
    end

    def add_listener(name, listener)
      unless listener.respond_to?(name)
        message = "#{listener.class.name} cannot respond to #{name}"
        raise ArgumentError, message
      end

      listeners[name] = [] unless listeners.dig(name)
      listeners[name] << listener unless include_listener?(name, listener)
    end

    def add_listeners(event_name, listeners)
      listeners.each do |l|
        add_listener(event_name, l)
      end
    end

    def remove_listener(event_name, listener)
      return unless listeners[event_name].present?

      listeners[event_name].each_with_index do |l, idx|
        if l.equal?(listener)
          listeners[event_name].delete_at(idx)
          break
        end
      end
    end

    def clear_all_listeners
      @listeners = {}
    end

    private

    def include_listener?(event_name, listener)
      listeners[event_name].select do |l|
        l.class == listener.class
      end.any?
    end

    def pubsub
      DarkPrism::Config::GcloudConfig.instance.pubsub
    end
  end
end
