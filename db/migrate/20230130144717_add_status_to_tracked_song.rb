class AddStatusToTrackedSong < ActiveRecord::Migration[7.0]
  def change
    add_column :tracked_songs, :status, :integer, default: 0
  end
end
