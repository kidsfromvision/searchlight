Rails.application.routes.draw do
  get "/search", to: "search#index"
  get "/search_popover", to: "search#search_popover", as: "search_popover"

  get "/admin", to: "admin#index", as: "admin_root"

  get "/admin_tools", to: "admin_tools#index", as: "admin_tools"
  post "/admin_tools/update_songs",
       to: "admin_tools#update_songs",
       as: "update_songs"

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
  post "add_tracked_song_to_label/:id",
       to: "tracked_song#add_tracked_song_to_label",
       as: "add_tracked_song_to_label"

  devise_for :users, controllers: { passwords: "users/passwords" }
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  get "list", to: "songs#list", as: "list_songs"
  get "label/list", to: "songs#label_list", as: "label_list_songs"

  get "label", to: "songs#label", as: "label_leaderboard"
  get "label/archives", to: "songs#label_archives", as: "label_archives"
  get "archives", to: "songs#archives", as: "archives"

  get "account", to: "account#index", as: "account"
  post "account/reset_password",
       to: "account#reset_password",
       as: "reset_password"

  root "songs#index"
end
