module JellyfishAws
  module Service
    class RDS < ::Service::Database
      def actions
        actions = super.merge :terminate
        actions
      end

      def deprovision
        handle_errors do
          # GET HANDLE OF SERVER INSTANCE TO BE DEPROVISIONED
          identifier = get_output('instance_id').value

          # DO NOT MAKE A BACKUP SNAPSHOT
          snapshot_id = ''
          skip_final_snap_shot = true

          # SEND THE SIGNAL TO SHUTDOWN AND TERMINATE THE INSTANCE
          client.delete_db_instance(identifier, snapshot_id, skip_final_snap_shot)

          # UPDATE STATUS
          update_status(::Service.defined_enums['status']['terminated'], 'terminated')
        end
      end

      def provision
        db = nil
        handle_errors do
          # UPDATE PRODUCT DETAILS
          instance_id = "id-#{SecureRandom.hex(10)}"
          details = {
            'Engine' => self.product.answers.find { |x| x.name == 'engine' }.value,
            'EngineVersion' => self.product.answers.find { |x| x.name == 'version' }.value,
            'DBInstanceClass'=> self.product.answers.find { |x| x.name == 'flavor_id' }.value,
            'AllocatedStorage' => self.product.answers.find { |x| x.name == 'allocated_storage' }.value,
            'MasterUsername' => self.answers.find { |x| x.name == 'master_username' }.value,
            'MasterUserPassword' => self.answers.find { |x| x.name == 'master_password' }.value
          }

          # CREATE THE AWS DB INSTANCE
          # TODO: WAIT FOR ACTUAL AWS PROVISIONING TO COMPLETE BEFORE SETTING STATUS TO RUNNING - POLL?
          # ISSUE: NoMethodError: undefined method `wait_for' for #<Excon::Response:0x007fdb08dda488>
          db = client.create_db_instance(instance_id, details)

          # SAVE DB INSTANCE DETAILS
          save_outputs(db.body['CreateDBInstanceResult']['DBInstance'], [ ['instance_id', 'DBInstanceIdentifier'] ], ValueTypes::TYPES[:string]) if defined? db.body['CreateDBInstanceResult']['DBInstance']

          # SAVE DB PRODUCT DETAILS
          save_outputs(details, [ ['engine', 'Engine'],
                                  ['version', 'EngineVersion'],
                                  ['flavor_id', 'DBInstanceClass'],
                                  ['allocated_storage', 'AllocatedStorage'],
                                  ['master_username','MasterUsername'],
                                  ['master_password','MasterUserPassword']], ValueTypes::TYPES[:string]) if defined? details

          # UPDATE STATUS
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
          self.provider.rds_client
        end
      end
    end
  end
end
