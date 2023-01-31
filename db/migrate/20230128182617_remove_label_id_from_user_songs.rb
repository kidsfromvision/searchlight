class RemoveLabelIdFromUserSongs < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_songs, :label_id
  end
end
