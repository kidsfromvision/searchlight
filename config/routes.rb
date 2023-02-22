Rails.application.routes.draw do
  get "/search", to: "search#index"

  get "/admin", to: "admin#index", as: "admin_root"

  post "/invitation", to: "invitation#create", as: "create_invitation"

  post "/song", to: "song#create"

  get "/tracked_song/:id", to: "tracked_song#index", as: "tracked_song"
  patch "/tracked_song/:id",
        to: "tracked_song#update",
        as: "update_tracked_song"
  patch "/tracked_song/:id/archive",
        to: "tracked_song#archive",
        as: "archive_tracked_song"
  patch "/tracked_song/:id/unarchive",
        to: "tracked_song#unarchive",
        as: "unarchive_tracked_song"
  delete "/tracked_song/:id", to: "tracked_song#remove"

  devise_for :users, controllers: { passwords: "users/passwords" }
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  get "list", to: "songs#list", as: "list_songs"

  get "archives", to: "songs#archives", as: "archives"

  get "account", to: "account#index", as: "account"
  post "account/reset_password",
       to: "account#reset_password",
       as: "reset_password"
  # Defines the root path route ("/")
  root "songs#index"
end
