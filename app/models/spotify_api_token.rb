class SpotifyApiToken < ApplicationRecord
  def expired?
    Time.now > self.expiry - 5.minutes
  end

  def refresh
    self.create_new_key
  end

  private

  def create_new_key
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
      SpotifyApiToken.create!(
        token: response["access_token"],
        expiry: Time.now + 1.hours,
      )
      self.destroy
    end
  end
end
