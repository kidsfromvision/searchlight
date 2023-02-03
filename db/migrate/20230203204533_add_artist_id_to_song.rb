class AddArtistIdToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :artist_id, :string
  end
end
