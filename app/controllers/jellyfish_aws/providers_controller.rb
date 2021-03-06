module JellyfishAws
  class ProvidersController < JellyfishAws::ApplicationController
    after_action :verify_authorized

    def ec2_flavors
      authorize :aws
      render json: provider.ec2_flavors
    end

    def rds_engines
      authorize :aws
      render json: provider.rds_engines
    end

    def rds_versions
      authorize :aws
      render json: provider.rds_versions(params[:engine])
    end

    def rds_flavors
      authorize :aws
      render json: provider.rds_flavors(params[:engine], params[:version])
    end

    def ec2_images
      authorize :aws
      render json: provider.ec2_images
    end

    def subnets
      authorize :aws
      render json: provider.subnets(params[:vpc_id])
    end

    def availability_zones
      authorize :aws
      render json: provider.availability_zones
    end

    def key_names
      authorize :aws
      render json: provider.key_names
    end

    def security_groups
      authorize :aws
      render json: provider.security_groups
    end

    def vpcs
      authorize :aws
      render json: provider.vpcs
    end

    def deprovision
      authorize :aws
      render json: provider.deprovision(params[:service_id])
    end

    private

    def provider
      @provider ||= ::Provider.find params[:id]
    end
  end
end
