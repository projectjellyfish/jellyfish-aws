module JellyfishAws
  module Service
    class Ec2 < ::Service::Compute
      def actions
        actions = super.merge :terminate
        actions
      end

      def provision
        server = nil

        handle_errors do
          # TODO: FIGURE OUT HOW SUBNET FITS HERE
          details = {
            image_id: self.product.answers.find { |x| x.name == 'image_id' }.value,
            flavor_id: self.product.answers.find { |x| x.name == 'flavor_id' }.value,
            key_name: self.product.answers.find { |x| x.name == 'key_name' }.value,
            security_group_ids: [ self.product.answers.find { |x| x.name == 'security_group_id' }.value ]
          }

          # CREATE THE AWS SERVER AND WAIT FOR CALLBACK
          server = client.servers.create(details).tap { |s| s.wait_for { ready? } }

          # PERSIST SERVER PUBLIC IP
          persist_attributes(server.attributes) if defined? server.attributes

          # SUCCESS OR FAIL NOTIFICATION
          self.status = ::Service.defined_enums['status']['running']
          self.status_msg = 'running'
          self.save
        end
      end

      def start

      end

      def stop

      end

      def terminate

      end

      private

      def persist_attributes(attributes)
        output = ServiceOutput.new name: 'public_ip_address', value: attributes[:public_ip_address], value_type: ValueTypes::TYPES[:string]
        self.service_outputs << output
      end

      def handle_errors
        yield
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Request failed, check for valid credentials and proper permissions.', e.backtrace
      end

      def client
        @client ||= begin
          credentials = {
            provider: 'AWS',
            aws_access_key_id: self.provider.settings[:access_id],
            aws_secret_access_key: self.provider.settings[:secret_key],
            region: self.provider.settings[:region]
          }
          Fog::Compute.new credentials
        end
      end
    end
  end
end
