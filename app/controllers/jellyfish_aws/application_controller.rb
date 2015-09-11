module JellyfishAws
  class ApplicationController < ::ApplicationController
    rescue_from Fog::Compute::AWS::Error, with: :aws_error

    protected

    def aws_error(ex)
      message, type = ex.message.split(' => ').reverse
      render json: {type: type, error: message}, status: :bad_request
    end
  end
end
