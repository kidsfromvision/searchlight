class RemoveStatusColumnFromSongs < ActiveRecord::Migration[7.0]
  def change
    remove_column :songs, :status
  end
end
