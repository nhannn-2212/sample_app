Rails.application.routes.draw do
  root "static_pages#home"

  get "/help", to: "static_pages#help", as: "help"
  get "/contact", to: "static_pages#contact", as: "contact"
  get "/signup", to: "users#new", as: "signup"

end
