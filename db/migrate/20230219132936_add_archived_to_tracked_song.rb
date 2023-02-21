class AddArchivedToTrackedSong < ActiveRecord::Migration[7.0]
  def change
    add_column :tracked_songs, :archived, :boolean, default: false
  end
end
