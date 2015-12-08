JellyfishAws::Engine.routes.draw do
  resources :providers, only: [] do
    member do
      get :ec2_flavors
      get :rds_engines
      get :rds_versions
      get :rds_flavors
      get :ec2_images
      get :vpcs
      get :subnets
      get :availability_zones
      get :key_names
      get :security_groups
      get :deprovision
    end
  end
end
