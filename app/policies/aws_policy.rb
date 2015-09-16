class AwsPolicy < ApplicationPolicy
  def ec2_flavors?
    logged_in?
  end

  def ec2_images?
    logged_in?
  end

  def subnets?
    logged_in?
  end

  def availability_zones?
    logged_in?
  end
end
