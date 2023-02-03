class SpotifyAuthManager < AuthManager
  class << self
    private

    def provider
      "spotify"
    end

    def get_token
      auth_key =
        Base64.strict_encode64(
          ENV["SPOTIFY_CLIENT_ID"] + ":" + ENV["SPOTIFY_CLIENT_SECRET"],
        )

      headers = { "Authorization" => "Basic #{auth_key}" }
      response =
        HTTParty.post(
          "https://accounts.spotify.com/api/token",
          headers: headers,
          query: {
            "grant_type" => "client_credentials",
          },
        )
      if response.code == 200
        return response["access_token"]
      else
        raise "Spotify token refresh failed"
      end
    end
  end
end
