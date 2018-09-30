require 'dark_prism/config/gcloud_config'

module DarkPrism
  module Config
    class MainConfig
      include Singleton
      attr_reader :dispatcher
      attr_accessor :logger, :enable_sentry

      def initialize
        @dispatcher = DarkPrism::Dispatcher.instance
        @enable_sentry = false

        init_logger
        init_sentry
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

      def enable_sentry=(use_sentry)
        @enable_sentry = use_sentry
      end

      def gcloud(&block)
        GcloudConfig.configure(&block)
      end


      private

      def remove_logger!
        @logger = nil
      end

      def init_logger
        if defined?(Rails) && defined?(Rails.logger)
          @logger = Rails.logger
          @dispatcher.logger = @logger
        else
          @logger = Logger.new(STDOUT)
        end
      end

      def init_sentry
        @dispatcher.enable_sentry = @enable_sentry
      end
    end
  end
end
