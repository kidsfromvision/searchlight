class AddSongReleaseDate < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :released, :date
  end
end
