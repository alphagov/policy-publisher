Rails.application.routes.draw do
  resources :policies

  get "/healthcheck" => Proc.new { [200, {}, ["OK"]] }

  root to: "policies#index"
end
