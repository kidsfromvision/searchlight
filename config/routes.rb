Rails.application.routes.draw do
  get "/search", to: "search#index"

  get "/admin", to: "admin#index", as: "admin_root"

  post "/invitation", to: "invitation#create", as: "create_invitation"

  post "/song", to: "song#create"

  get "/tracked_song/:id", to: "tracked_song#index", as: "tracked_song"
  patch "/tracked_song/:id",
        to: "tracked_song#update",
        as: "update_tracked_song"
  delete "/tracked_song/:id", to: "tracked_song#remove"

  devise_for :users
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  get "list", to: "songs#list", as: "list_songs"

  # Defines the root path route ("/")
  root "songs#index"
end
