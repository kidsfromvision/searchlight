class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist
      t.string :chartmetric_id
      t.boolean :pinned

      t.timestamps
    end
    add_column :songs, :status, :integer, default: 0
  end
end
