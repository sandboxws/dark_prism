module DarkPrism
  module Dispatch
    extend ActiveSupport::Concern

    included do
      def dispatch_event(event_name, event)
        DarkPrism::Dispatcher.instance.dispatch(event_name, event)
      end
    end
  end
end
