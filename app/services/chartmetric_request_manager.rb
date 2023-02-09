class ChartmetricRequestManager
  class << self
    def get_streams(song)
      last_updated = last_update_date(song)
      if last_updated.nil? || Time.now > last_updated + 1.days
        stream_event = song.stream_events.create(provider: "chartmetric")
        headers = {
          "Authorization" => "Bearer #{ChartmetricAuthManager.token}",
        }
        response =
          HTTParty.get(
            "https://api.chartmetric.com/api/track/#{song.spotify_id}/spotify/stats/most-history?isDomainId=true&type=streams#{since_query(last_updated)}",
            headers: headers,
          )
        stream_event.status = "success"
        stream_event.save
        return response["obj"].first["data"] if response["obj"].length > 0

        stream_event.status = "failed"
        stream_event.save
      end
      []
    end

    private

    def last_update_date(song)
      streams = song.song_streams
      streams.last.nil? ? nil : streams.last.date
    end

    def since_query(last_updated)
      return "" unless last_updated

      "&since=#{(last_updated + 1.days).strftime("%Y-%m-%d")}"
    end
  end
end
