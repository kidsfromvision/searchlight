class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    query = params[:query]
    @previously_added_songs = previously_added_songs
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

  private

  def previously_added_songs
    if current_user.label_id
      @previously_added_songs ||=
        Song
          .joins(:tracked_songs)
          .joins(:user)
          .where(user: { label_id: current_user.label_id })
          .distinct
    else
      @previously_added_songs ||= current_user.songs
    end
  end
end
