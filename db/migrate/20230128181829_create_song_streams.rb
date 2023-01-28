class CreateSongStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :song_streams do |t|
      t.integer :streams
      t.timestamp :date

      t.timestamps
    end
    
    add_reference :song_streams, :song
    add_foreign_key :song_streams, :songs
  end
end
