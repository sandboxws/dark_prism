module DarkPrism
  module Config
    class GcloudConfig
      include Singleton
      attr_reader :pubsub
      attr_accessor :project_id, :credentials

      def self.configure(&block)
        raise NoBlockGivenException unless block_given?

        instance = GcloudConfig.instance
        instance.instance_eval(&block)

        instance
      end

      def initialize
        prepare_pubsub
      end

      def prepare_pubsub
        return unless valid?

        @pubsub = Google::Cloud::Pubsub.new(
          project: project_id,
          keyfile: credentials
        )
      end

      def valid?
        !project_id.nil? && !credentials.nil?
      end
    end
  end
end
