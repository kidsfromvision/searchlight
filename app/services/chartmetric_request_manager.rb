class ChartmetricRequestManager
  class << self
    def get_streams(song)
      last_updated = last_update_date(song)
      if last_updated.nil? || Time.now > last_updated + 1.days
        stream_event =
          song.song_request_events.create(
            provider: "chartmetric",
            data_requested: "streams",
          )
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
        return response["obj"].first["data"] if !response["obj"]&.empty?

        stream_event.status = "failed"
        stream_event.save
      end
      []
    end

    def get_genres(song)
      headers = { "Authorization" => "Bearer #{ChartmetricAuthManager.token}" }
      chartmetric_id = get_chartmetric_id(song.spotify_id, headers)
      genres_event =
        song.song_request_events.create(
          provider: "chartmetric",
          data_requested: "genres",
        )
      response =
        HTTParty.get(
          "https://api.chartmetric.com/api/track/#{chartmetric_id}",
          headers: headers,
        )

      genres_event.status = "success"
      genres_event.save
      return response["obj"]["tags"] unless response["obj"]&.empty?

      genres_event.status = "failed"
      genres_event.save
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

    def get_chartmetric_id(spotify_id, headers)
      response =
        HTTParty.get(
          "https://api.chartmetric.com/api/track/spotify/#{spotify_id}/get-ids",
          headers: headers,
        )
      response["obj"][0]["chartmetric_ids"][0] unless response["obj"].empty?
    end
  end
end
