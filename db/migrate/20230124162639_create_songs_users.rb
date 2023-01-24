class CreateSongsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :songs_users, id: false do |t|
      t.belongs_to :song
      t.belongs_to :user
    end
  end
end
