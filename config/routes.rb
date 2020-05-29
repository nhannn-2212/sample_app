Rails.application.routes.default_url_options[:host] = "localhost:3000"
Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
    root "static_pages#home"

    get "/help", to: "static_pages#help", as: "help"
    get "/contact", to: "static_pages#contact", as: "contact"
    get "/signup", to: "users#new", as: "signup"
    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: "logout"

    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new edit create update)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end
end
