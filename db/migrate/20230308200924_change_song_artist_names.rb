class ChangeSongArtistNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :songs, :artist, :artist_name
    rename_column :songs, :artist_id, :artist_spotify_id
  end
end
