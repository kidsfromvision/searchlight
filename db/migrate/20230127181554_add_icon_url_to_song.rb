class AddIconUrlToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :icon_url, :string
  end
end
