class RemoveArtistNameAndSpotifyIdFromSong < ActiveRecord::Migration[7.0]
  def change
    remove_column :songs, :artist_name
    remove_column :songs, :artist_spotify_id
  end
end
