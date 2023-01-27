class AddStreamToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :stream, :integer
  end
end
