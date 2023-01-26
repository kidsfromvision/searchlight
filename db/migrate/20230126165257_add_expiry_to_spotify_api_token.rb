class AddExpiryToSpotifyApiToken < ActiveRecord::Migration[7.0]
  def change
    add_column :spotify_api_tokens, :expiry, :timestamp
  end
end
