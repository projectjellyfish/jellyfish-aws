module JellyfishAws
  class ProvidersController < JellyfishAws::ApplicationController
    after_action :verify_authorized

    def ec2_flavors
      authorize :aws
      render json: provider.ec2_flavors
    end

    def ec2_images
      authorize :aws
      render json: provider.ec2_images
    end

    def subnets
      authorize :aws
      render json: provider.subnets
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

    private

    def provider
      @provider ||= ::Provider.find params[:id]
    end
  end
end
