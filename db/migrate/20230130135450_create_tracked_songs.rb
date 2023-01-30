class CreateTrackedSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :tracked_songs do |t|
      t.timestamps
    end

    add_reference :tracked_songs, :label
    add_reference :tracked_songs, :song
    add_reference :tracked_songs, :user

    add_foreign_key :tracked_songs, :labels
    add_foreign_key :tracked_songs, :users
    add_foreign_key :tracked_songs, :songs

    add_column :songs, :status, :integer, default: 0
  end
end
