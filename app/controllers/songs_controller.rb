class SongsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.label_id
      @label = current_user.label
      @songs = @label.songs
    else
      @label = nil
      @songs = current_user.songs
    end

    # @songs.each { |song|song.stream = 0}
    # chartmetric_api_token = ChartmetricApiToken.first
    # chartmetric_api_token.refresh if chartmetric_api_token.expired?
    
    # @token = ChartmetricApiToken.first.token
    # headers = { "Authorization" => "Bearer #{@token}" }
    # @songs.each do |song|
    #   begin
    #     @response = HTTParty.get("https://api.chartmetric.com/api/track/#{song.spotify_id}/spotify/stats/most-history?isDomainId=true&type=streams&since=2023-01-10", headers: headers)
    #     data = response["obj"].first["data"]
    #     if data.length >= 2
    #       song.stream = data[-1]["value"] - data[-2]["value"]
    #     else
    #       song.stream = 0
    #     end
    #   rescue
    #     song.stream = 0
    #   end
    # end
    
  end
end
