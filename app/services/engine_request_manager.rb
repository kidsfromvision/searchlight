class EngineRequestManager
  class << self
    def create_artist_metadata(artist_id)
      pathfinder_url = "http://127.0.0.1:8081/artist/create_metadata"
      url = "#{pathfinder_url}/?artist_id=#{artist_id}"
      response = HTTParty.post(url)
      response.parsed_response
    end
  end
end
