module DarkPrism
  module Dispatch
    extend ActiveSupport::Concern

    included do
      def dispatch_event(event_name, obj)
        DarkPrism::Dispatcher.instance.dispatch(event_name, obj)
      end

      def dispatch_pubsub(topic_name, message, attributes = nil)
        DarkPrism::Dispatcher.instance.dispatch_pubsub(
          topic_name,
          message,
          attributes
        )
      end

      def dispatch_pubsub_async(topic_name, message, attributes = nil)
        DarkPrism::Dispatcher.instance.dispatch_pubsub_async(
          topic_name,
          message,
          attributes
        )
      end
    end
  end
end
