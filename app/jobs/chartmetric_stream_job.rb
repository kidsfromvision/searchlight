class ChartmetricStreamJob < ActiveJob::Base
  queue_as :default

  def perform(song, user)
    stream_event = song.stream_events.create(provider: "chartmetric")
    song.broadcast_streams_loading
    song_streams =
      song.song_streams.where(provider: "chartmetric").order("date DESC")

    if song_streams && song_streams.length > 0
      since_query =
        "&since=#{(song_streams[0].date + 1.days).strftime("%Y-%m-%d")}"
    else
      since_query = ""
    end

    headers = { "Authorization" => "Bearer #{ChartmetricAuthManager.token}" }
    response =
      HTTParty.get(
        "https://api.chartmetric.com/api/track/#{song.spotify_id}/spotify/stats/most-history?isDomainId=true&type=streams#{since_query}",
        headers: headers,
      )

    if response && response["obj"].length > 0
      data = response["obj"].first["data"]
      song.song_streams.create(
        data.map do |stream|
          { streams: stream["value"], date: stream["timestp"] }
        end,
      )
      stream_event.status = "success"
    else
      stream_event.status = "failed"
    end

    song.broadcast_streams
    stream_event.save
  end
end
