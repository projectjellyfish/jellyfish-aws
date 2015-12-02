module JellyfishAws
  module ProductType
    class S3 < ::ProductType
      def self.load_product_types
        return unless super

        # TODO: ADD RDS BACK WITH THOUGHTFUL IMPLEMENTATION
        # transaction do
        #   [
        #     set('S3 Instance', '11ca0e0e-617d-45f3-b10a-acf42d5e6ecc', provider_type: 'JellyfishAws::Provider::Aws', active: 'false')
        #   ].each do |s|
        #     create! s.merge!(type: 'JellyfishAws::ProductType::S3')
        #   end
        # end
      end

      def description
        'Amazon Web Services Scalable Cloud Storage Instance'
      end

      def tags
        ['s3', 'storage', 'cdn']
      end

      def product_questions
        [
        ]
      end

      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishAws::Service::S3'.constantize
      end
    end
  end
end
