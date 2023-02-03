class AddProviderColumnToSongStreams < ActiveRecord::Migration[7.0]
  def change
    add_column :song_streams, :provider, :integer, default: 0
  end
end
