class SearchController < ApplicationController
  def index
    query = params[:query]

    spotify_api_token = SpotifyApiToken.first
    spotify_api_token.refresh if spotify_api_token.expired?

    token = SpotifyApiToken.first.token
    headers = { "Authorization" => "Bearer #{token}" }
    response =
      HTTParty.get(
        "https://api.spotify.com/v1/search?type=track&q=#{query}",
        headers: headers,
      )
			
    @results = response["tracks"]["items"]
  end
end
