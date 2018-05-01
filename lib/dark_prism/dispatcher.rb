module DarkPrism
  class Dispatcher
    include Singleton
    attr_reader :listeners

    def initialize
      @listeners = {}
    end

    def dispatch(event_name, event)
      @listeners.dig(event_name).each do |listener|
        listener.send(event_name, event)
      end
    end

    def add_listener(event_name, listener)
      unless listener.respond_to?(event_name)
        raise ArgumentError, "Listener cannot respond to #{event_name} event"
      end

      unless listeners.dig(event_name)
        listeners[event_name] = []
      end

      unless include_listener?(event_name, listener)
        listeners[event_name] << listener
      end
    end

    def add_listeners(event_name, listeners)
      listeners.each do |l|
        add_listener(event_name, l)
      end
    end

    def remove_listener(event_name, listener)
      unless listeners[event_name].nil?
        listeners[event_name].each_with_index do |l, idx|
          if l.equal?(listener)
            listeners[event_name].delete_at(idx)
          end
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
      end.size > 0
    end
  end
end
