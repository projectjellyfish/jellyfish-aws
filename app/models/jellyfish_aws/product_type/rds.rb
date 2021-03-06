module JellyfishAws
  module ProductType
    class RDS < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('RDS Instance', 'fbd69f29-4150-4ea3-9ff1-90ae33f4a1f4', provider_type: 'JellyfishAws::Provider::Aws')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAws::ProductType::RDS')
          end
        end
      end

      def description
        'Amazon Web Services Database Instance'
      end

      def tags
        ['rds', 'database']
      end

      def product_questions
        [
          { name: :engine, value_type: :string, field: :aws_rds_engines, required: true },
          { name: :version, value_type: :string, field: :aws_rds_versions, required: true },
          { name: :flavor_id, value_type: :string, field: :aws_rds_flavors, required: true },
          { name: :allocated_storage, value_type: :string, field: :text, label: 'Allocated Storage', required: true },
          { name: :master_username, value_type: :string, field: :aws_rds_admin_username, required: true },
          { name: :master_password, value_type: :string, field: :aws_rds_admin_password, required: true }
        ]
      end

      def product_class
        'JellyfishAws::Product::RDS'.constantize
      end
    end
  end
end
