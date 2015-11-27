module JellyfishAws
  module ProductType
    class Ec2 < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('EC2 Instance', 'd16d5017-6d6b-4775-958f-535f68b4cf04', provider_type: 'JellyfishAws::Provider::Aws')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAws::ProductType::Ec2')
          end
        end
      end

      def description
        'Amazon Web Services Elastic Compute Cloud Instance'
      end

      def tags
        ['ec2', 'server']
      end

      def product_questions
        [
          { name: :flavor_id, value_type: :string, field: :aws_ec2_flavors, required: true },
          { name: :image_id, value_type: :string, field: :aws_ec2_images, required: true },
          { name: :subnet_id, value_type: :string, field: :aws_subnets, required: true },
          { name: :key_name, value_type: :string, field: :aws_key_names, required: true },
          { name: :security_group_id, value_type: :string, field: :aws_security_groups, required: true }
        ]
      end

      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishAws::Service::Ec2'.constantize
      end
    end
  end
end
