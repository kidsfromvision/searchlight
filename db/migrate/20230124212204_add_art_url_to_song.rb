class AddArtUrlToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :art_url, :string
  end
end
