Rails.application.routes.draw do
  resources :policy_areas
  resources :programmes

  get "/healthcheck" => Proc.new { [200, {}, ["OK"]] }

  root to: "policy_areas#index"
end
