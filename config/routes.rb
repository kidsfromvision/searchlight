Rails.application.routes.draw do
  get "/search", to: "search#index"

  post "/song", to: "song#create"
  get "/song/:id", to: "song#index"
  delete "/song/:id", to: "song#remove"

  devise_for :users
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "songs#index"
end
