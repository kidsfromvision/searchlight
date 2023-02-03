class ChartmetricStreamJob < ActiveJob::Base
  queue_as :default

  def perform(song, user)
    song_streams =
      song.song_streams.where(provider: "chartmetric").order("date DESC")
    if song_streams.length > 0
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

    if response && response["obj"]
      data = response["obj"].first["data"]
      if data
        song.song_streams.create(
          data.map do |stream|
            { streams: stream["value"], date: stream["timestp"] }
          end,
        )
      end
    end

    Turbo::StreamsChannel.broadcast_replace_to(
      "chartmetric_streams",
      target: "song_#{song.id}",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
      },
    )
  end
end
