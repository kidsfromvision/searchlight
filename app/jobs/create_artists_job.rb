class CreateArtistsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # For every song, extract the artist name and spotify ID, create artist. make sure the artist is unique
    Song.all.each do |song|
      artist_name = song.artist_name
      artist_spotify_id = song.artist_spotify_id
      if Artist.exists?(spotify_id: artist_spotify_id)
        artist = Artist.find_by(spotify_id: artist_spotify_id)
      else
        artist = Artist.create(name: artist_name, spotify_id: artist_spotify_id)
      end
      song.artist = artist
      song.save
    end
  end
end
