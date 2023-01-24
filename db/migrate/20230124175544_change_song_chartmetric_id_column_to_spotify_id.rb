class ChangeSongChartmetricIdColumnToSpotifyId < ActiveRecord::Migration[7.0]
  def change
    rename_column :songs, :chartmetric_id, :spotify_id
  end
end
