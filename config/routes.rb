Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :v1 do
    resources :schedules, only: :index do
      resources :events
      resources :rooms, only: :index
    end
  end
end
