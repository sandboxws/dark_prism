require 'dark_prism/config/gcloud_config'

module DarkPrism
  module Config
    class MainConfig
      include Singleton
      attr_reader :dispatcher

      def initialize
        @dispatcher = DarkPrism::Dispatcher.instance
      end

      def self.configure(&block)
        raise NoBlockGivenException unless block_given?
        instance = MainConfig.instance
        instance.instance_eval(&block)

        instance
      end

      def register_listeners(klass_mod)
        klass_mod.listeners.each do |event_name, listeners|
          dispatcher.add_listeners(event_name, listeners)
        end
      end

      def gcloud(&block)
        GcloudConfig.configure(&block)
      end
    end
  end
end
