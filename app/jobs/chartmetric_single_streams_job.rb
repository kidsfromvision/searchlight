class ChartmetricSingleStreamsJob < ActiveJob::Base
  queue_as :default

  def perform(song)
    song.broadcast_streams_loading
    streams = ChartmetricRequestManager.get_streams(song)
    unless streams.empty?
      song.song_streams.create(
        streams.map do |stream|
          { streams: stream["value"], date: stream["timestp"] }
        end,
      )
    end
    song.broadcast_streams
    SpotifySingleStreamsJob.perform_later(song)
  end
end
