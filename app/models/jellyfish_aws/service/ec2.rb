module JellyfishAws
  module Service
    class Ec2 < ::Service::Compute
      def actions
        actions = super.merge :terminate
        actions
      end

      def deprovision
        handle_errors do
          server_identifier = get_output('instance_id').value
          client.servers.get(server_identifier).destroy

          # UPDATE STATUS
          update_status(::Service.defined_enums['status']['terminated'], 'terminated')
        end
      end

      def provision
        server = nil

        handle_errors do
          # TODO: EACH ANSWER SHOULD BE AN OPTIONAL DETAIL IF THEY EXIST
          details = {
            image_id: self.product.answers.find { |x| x.name == 'image_id' }.value,
            flavor_id: self.product.answers.find { |x| x.name == 'flavor_id' }.value,
            key_name: self.product.answers.find { |x| x.name == 'key_name' }.value,
            vpc_id: self.product.answers.find { |x| x.name == 'vpc_id' }.value,
            subnet_id: self.product.answers.find { |x| x.name == 'subnet_id' }.value,
            security_group_ids: [ self.product.answers.find { |x| x.name == 'security_group_id' }.value ]
          }

          # CREATE THE AWS SERVER AND WAIT FOR CALLBACK
          server = client.servers.create(details).tap { |s| s.wait_for { ready? } }

          # PERSIST SERVER PUBLIC IP
          persist_attributes(server.attributes) if defined? server.attributes

          # UPDATE STATUS
          update_status(::Service.defined_enums['status']['running'], 'running')
        end
      end

      def start

      end

      def stop

      end

      def terminate

      end

      private

      def update_status(status, status_msg)
        self.status = status
        self.status_msg = status_msg
        self.save
      end

      def persist_attributes(attributes)
        save_output('public_ip_address', attributes[:public_ip_address], ValueTypes::TYPES[:string])
        save_output('instance_id', attributes[:id], ValueTypes::TYPES[:string])
      end

      def save_output(name, value, value_type)
        service = get_output(name) || self.service_outputs.new(name: name, value: value, value_type: value_type)
        service.update_attributes(value: value, value_type: value_type) unless service.nil?
      end

      def get_output(name)
        self.service_outputs.where(name: name).first
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
