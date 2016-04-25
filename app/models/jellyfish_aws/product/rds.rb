module JellyfishAws
  module Product
    class RDS < ::Product
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
