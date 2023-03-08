class AddArtistForeignKeyToSong < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :songs, :artists
  end
end
