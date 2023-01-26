class CreateSpotifyApiTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :spotify_api_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
