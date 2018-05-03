module DarkPrism
  module Config
    class GcloudConfig
      include Singleton
      attr_reader :pubsub
      attr_writer :project_id, :credentials

      def initialize
        prepare_pubsub
      end

      def prepare_pubsub
        @pubsub = Google::Cloud::Pubsub.new(
          project: project_id,
          keyfile: credentials
        )
      end

      def self.configure(&block)
        raise NoBlockGivenException unless block_given?

        instance = GcloudConfig.instance
        instance.instance_eval(&block)

        puts instance
        instance
      end

      def valid?
        !project_id.nil? && !credentials.nil?
      end
    end
  end
end
