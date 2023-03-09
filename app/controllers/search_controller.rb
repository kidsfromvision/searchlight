class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @previously_added_songs = previously_added_songs
    @results = get_results()
  end

  def search_popover
    broadcast_popover_loading
    @previously_added_songs = previously_added_songs
    @results = get_results(5)
    broadcast_popover_loaded(@results, @previously_added_songs)
  end

  private

  def get_results(limit = 10)
    query = URI.encode_uri_component(params[:query])
    if query.blank?
      @results = []
    else
      headers = { "Authorization" => "Bearer #{SpotifyAuthManager.token}" }
      response =
        HTTParty.get(
          "https://api.spotify.com/v1/search?type=track&limit=#{limit}&q=#{query}",
          headers: headers,
        )
      @results = response["tracks"]["items"]
    end
  end

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

  def broadcast_popover_loaded(results, previously_added_songs)
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "search_popover",
      partial: "search/search_popover",
      locals: {
        results: results,
        previously_added_songs: previously_added_songs,
        query: params[:query],
      },
    )
  end

  def broadcast_popover_loading
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "search_popover",
      partial: "search/search_popover_loading",
    )
  end
end
