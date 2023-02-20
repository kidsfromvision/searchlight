class AddTypeToSongRequestEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :song_request_events, :data_requested, :integer, default: 0
  end
end
