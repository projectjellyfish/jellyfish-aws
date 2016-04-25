module JellyfishAws
  module Product
    class Ec2 < ::Product
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
