module JellyfishAws
  module ProductType
    class S3 < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('S3 Instance', '31f97b65-6b61-47b6-ae12-38cf22e27872', provider_type: 'JellyfishAws::Provider::Aws', active: 'false')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAws::ProductType::S3')
          end
        end
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

      def product_class
        'JellyfishAws::Product::S3'.constantize
      end
    end
  end
end
