JellyfishAws::Engine.routes.draw do
  resources :providers, only: [] do
    member do
      get :ec2_flavors
      get :ec2_images
      get :subnets
      get :availability_zones
      get :key_names
      get :security_groups
    end
  end
end
