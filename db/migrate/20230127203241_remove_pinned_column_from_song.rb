class RemovePinnedColumnFromSong < ActiveRecord::Migration[7.0]
  def change
    remove_column :songs, :pinned
  end
end
