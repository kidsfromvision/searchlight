class CreateUserSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_songs do |t|
      t.integer :user_id
      t.integer :song_id
      t.boolean :is_pinned, default: false

      t.timestamps
    end
    add_index :user_songs, %i[user_id song_id], unique: true
  end
end
