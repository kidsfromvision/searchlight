class DeleteSongsUsers < ActiveRecord::Migration[7.0]
  def change
    drop_table :songs_users
  end
end
