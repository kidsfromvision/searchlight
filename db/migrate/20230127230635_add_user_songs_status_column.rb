class AddUserSongsStatusColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :user_songs, :status, :integer, default: 0
  end
end
