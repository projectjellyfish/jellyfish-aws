module JellyfishAws
  module Service
    class RDS < ::Service::Database
      def actions
        actions = super.merge :terminate
        actions
      end

      def deprovision
        handle_errors do
          # client.delete_bucket(get_output('instance_id').value)
          # snapshot_id = skip_final_snap_shot ? '' : snapshot
          # connection.delete_db_instance(identifier, snapshot_id, skip_final_snap_shot)
          update_status(::Service.defined_enums['status']['terminated'], 'terminated')
        end
      end

      def provision
        db = nil
        handle_errors do
          # instance_id = "id-#{SecureRandom.hex(10)}"
          # details = {
          #   flavor_id: self.product.answers.find { |x| x.name == 'flavor_id' }.value,
          #   engine: self.product.answers.find { |x| x.name == 'engine' }.value,
          #   allocated_storage: self.product.answers.find { |x| x.name == 'allocated_storage' }.value,
          #   master_username: self.product.answers.find { |x| x.name == 'master_username' }.value,
          #   password: self.product.answers.find { |x| x.name == 'password' }.value
          # }
          # db = connection.create_db_instance(instance_id, details)
          # binding.pry
          # @order_item.payload_response['raw']['data']['body']['CreateDBInstanceResult']['DBInstance']['DBInstanceIdentifier']
          # save_outputs({ key: storage.key }, [ [ 'instance_id', :key ] ], ValueTypes::TYPES[:string]) if defined? storage
          update_status(::Service.defined_enums['status']['running'], 'running')
        end
      end

      private

      def update_status(status, status_msg)
        self.status = status
        self.status_msg = status_msg
        self.save
      end

      def save_outputs(source, outputs_to_save, output_value_type)
        outputs_to_save.each do |output_name, source_key|
          next unless defined? source[source_key]
          service = get_output(output_name) || self.service_outputs.new(name: output_name)
          service.update_attributes(value: source[source_key], value_type: output_value_type) unless service.nil?
          service.save
        end
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
            aws_access_key_id: self.provider.settings[:access_id],
            aws_secret_access_key: self.provider.settings[:secret_key],
            region: self.provider.settings[:region]
          }
          ::Fog::AWS::RDS.new credentials
        end
      end
    end
  end
end
