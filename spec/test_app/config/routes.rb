Rails.application.routes.draw do

  mount JellyfishAws::Engine => "/jellyfish_aws"
end
