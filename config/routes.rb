Rails.application.routes.draw do
  resources :tasks
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :sprints
      resources :tasks
    end
  end

  # resources :shorteners
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "home#index"
end
