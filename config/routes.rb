Rails.application.routes.draw do
  root "static_pages#home"

  get "/help", to: "static_pages#help", as: "help"
  get "/contact", to: "static_pages#contact", as: "contact"
  get "/signup", to: "users#new", as: "signup"
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :users
end
