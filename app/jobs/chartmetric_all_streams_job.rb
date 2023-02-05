class ChartmetricAllStreamsJob < ApplicationJob
  queue_as :default

  def perform
    songs = Song.all
    songs.each do |song|
      song.broadcast_streams_loading
      streams = ChartmetricRequestManager.get_streams(song)
      if streams.length > 0
        song.song_streams.create(
          streams.map do |stream|
            { streams: stream["value"], date: stream["timestp"] }
          end,
        )
      end
      song.broadcast_streams
    end
  end
end
