Rails.application.routes.draw do
  get "/search", to: "search#index"

  get "/admin", to: "admin#index", as: "admin_root"

  post "/invitation", to: "invitation#create", as: "create_invitation"

  post "/song", to: "song#create"
  get "/song/:id", to: "song#index", as: "single_song"
  delete "/song/:id", to: "song#remove"

  patch "/tracked_song/:id",
        to: "tracked_song#update",
        as: "update_tracked_song"

  devise_for :users
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "songs#index"
end
