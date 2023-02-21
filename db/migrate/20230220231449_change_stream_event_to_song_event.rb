class ChangeStreamEventToSongEvent < ActiveRecord::Migration[7.0]
  def change
    rename_table :stream_events, :song_request_events
  end
end
