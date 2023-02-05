class ChartmetricSingleStreamsJob < ActiveJob::Base
  queue_as :default

  def perform(song)
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
