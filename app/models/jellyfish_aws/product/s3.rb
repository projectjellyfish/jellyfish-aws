module JellyfishAws
  module Product
    class S3 < ::Product
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
