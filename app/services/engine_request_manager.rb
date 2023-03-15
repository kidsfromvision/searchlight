class EngineRequestManager
  class << self
    def create_artist_metadata(artist_id)
      pathfinder_url = "http://172.18.0.6:8080/artist/create_metadata"
      url = "#{pathfinder_url}/?artist_id=#{artist_id}"
      response = HTTParty.post(url)
      response.parsed_response
    end

    def get_song_playcount(spotify_id)
      url = "http://172.18.0.6:8080/spotify/song/#{spotify_id}/playcount"
      response = HTTParty.get(url)
      puts "RESPONSE, #{response.parsed_response["playcount"]}"
      response.parsed_response["playcount"]
    end
  end
end
