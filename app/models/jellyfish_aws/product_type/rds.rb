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
        # TODO: PLUGIN THE ENDPOINTS FOR THE FIELDS
        [
          { name: :flavor_id, value_type: :string, field: :text, label: 'Instance Type', required: true },
          { name: :engine, value_type: :string, field: :text, label: 'Database Engine', required: true },
          { name: :allocated_storage, value_type: :string, field: :text, label: 'Allocated Storage', required: true },
          { name: :master_username, value_type: :string, field: :text, label: 'Admin Username', required: true },
          { name: :master_username, value_type: :string, field: :text, label: 'Admin Password', required: true }
        ]
      end

      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishAws::Service::RDS'.constantize
      end
    end
  end
end
