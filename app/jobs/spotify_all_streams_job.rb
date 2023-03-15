class SpotifyAllStreamsJob < ApplicationJob
  queue_as :default

  def perform()
    songs = Song.all
    songs.each { |song| SpotifySingleStreamsJob.perform_now(song) }
  end
end
