class ChartmetricAllStreamsJob < ApplicationJob
  queue_as :default

  def perform
    songs = Song.all
    songs.each { |song| ChartmetricSingleStreamsJob.perform_now(song) }
  end
end
