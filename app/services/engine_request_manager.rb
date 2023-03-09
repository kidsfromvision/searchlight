class EngineRequestManager
  class << self
    def create_artist_metadata(artist_id)
      pathfinder_url = "http://172.18.0.6:8080/artist/create_metadata"
      url = "#{pathfinder_url}/?artist_id=#{artist_id}"
      response = HTTParty.post(url)
      response.parsed_response
    end
  end
end
