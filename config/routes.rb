Rails.application.routes.default_url_options[:host] = "localhost:3000"
Rails.application.routes.draw do
  root "static_pages#home"

  get "/help", to: "static_pages#help", as: "help"
  get "/contact", to: "static_pages#contact", as: "contact"
  get "/signup", to: "users#new", as: "signup"
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :users
  resources :account_activations, only: :edit
  resources :password_resets, only: %i(new edit create update)
end
