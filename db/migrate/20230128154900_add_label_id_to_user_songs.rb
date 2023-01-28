class AddLabelIdToUserSongs < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_songs, :label
    add_foreign_key :user_songs, :labels
    add_index :user_songs, %i[label_id song_id], unique: true
  end
end
