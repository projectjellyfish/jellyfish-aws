class AwsPolicy < ApplicationPolicy
  def ec2_flavors?
    logged_in?
  end

  def ec2_images?
    logged_in?
  end

  def vpcs?
    logged_in?
  end

  def subnets?
    logged_in?
  end

  def availability_zones?
    logged_in?
  end

  def key_names?
    logged_in?
  end

  def security_groups?
    logged_in?
  end
end
