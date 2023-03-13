class ChartmetricGenresJob < ApplicationJob
  queue_as :default

  def perform(song)
    song.broadcast_genres_loading
    genres = ChartmetricRequestManager.get_genres(song)
    song.genres = genres unless genres.nil?
    song.save
    song.broadcast_genres
  end
end
