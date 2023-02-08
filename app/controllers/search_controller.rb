class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    query = params[:query]
    if query.blank?
      @results = []
    else
      headers = { "Authorization" => "Bearer #{SpotifyAuthManager.token}" }
      response =
        HTTParty.get(
          "https://api.spotify.com/v1/search?type=track&q=#{query}",
          headers: headers,
        )

      @results = response["tracks"]["items"]
    end
  end
end
