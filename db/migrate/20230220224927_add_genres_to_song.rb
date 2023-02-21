class AddGenresToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :genres, :string
  end
end
