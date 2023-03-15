class SpotifySingleStreamsJob < ApplicationJob
  queue_as :default

  def perform(song)
    stream_event =
      song.song_request_events.create(
        provider: "spotify",
        data_requested: "streams",
      )
    song.broadcast_streams_loading
    playcount = EngineRequestManager.get_song_playcount(song.spotify_id)
    unless playcount.nil?
      song.song_streams.create(
        streams: playcount,
        date: Date.today,
        provider: "spotify",
      )
      stream_event.status = "success"
      stream_event.save
    else
      stream_event.status = "failure"
      stream_event.save
    end
    song.broadcast_streams
  end
end
