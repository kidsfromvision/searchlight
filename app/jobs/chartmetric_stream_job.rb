class ChartmetricStreamJob < ActiveJob::Base
  queue_as :default

  def perform(song)
    chartmetric_api_token = ChartmetricApiToken.first
    chartmetric_api_token.refresh if chartmetric_api_token.expired?
    song.stream = 0
    song.save
    token = ChartmetricApiToken.first.token
    headers = { "Authorization" => "Bearer #{token}" }
    response = HTTParty.get("https://api.chartmetric.com/api/track/#{song.spotify_id}/spotify/stats/most-history?isDomainId=true&type=streams&since=2023-01-10", headers: headers)
    if response && response["obj"]
      data = response["obj"].first["data"]
      if data.length >= 2
        song.stream = data[-1]["value"] - data[-2]["value"]
        song.save
        # @song_stream = SongStream.find_or_create_by(:id)
      end
    else
    end
    if song.save
    Turbo::StreamsChannel.broadcast_replace_to(
        "chartmetric_streams",
        target: "song_#{song.id}",
        partial: "songs/song",
        locals: {
          song: song,
        },
      )
    end
  end
end
