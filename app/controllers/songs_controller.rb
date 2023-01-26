class SongsController < ApplicationController
  def create
    @song = Song.new(params.permit(:name, :artist, :art_url, :spotify_id))
    @song.user << current_user
    redirect_to root_path if @song.save
  end
end
