class AwsPolicy < ApplicationPolicy
  def ec2_flavors?
    any_user!
  end

  def ec2_images?
    any_user!
  end

  def subnets?
    any_user!
  end

  def availability_zones?
    any_user!
  end
end
