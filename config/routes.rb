Rails.application.routes.draw do
  resources :policies
  resources :policy_areas
  resources :programmes

  get "/healthcheck" => Proc.new { [200, {}, ["OK"]] }

  root to: "policies#index"
end
