Rails.application.routes.draw do
  resources :policies

  root to: "policies#index"
end
