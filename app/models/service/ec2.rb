class Service < ActiveRecord::Base
  class Ec2 < Service::Compute
    def actions
      actions = super.merge :terminate

      # determine if action is available

      actions
    end

    def provision
=begin
  create key_pair name: service.uuid
  create security group (one per project) name: project-{id}
  create vpc (one per project) name: project-{id}
=end
    end

    def start

    end

    def stop

    end

    def terminate

    end

    private

    def client
      @client ||= provider.settings
    end
  end
end
