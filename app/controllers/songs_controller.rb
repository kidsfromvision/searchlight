class SongsController < ApplicationController
  before_action :authenticate_user!
  def index
    @songs = get_songs()
  end

  def create
    @song = Song.new(params.permit(:name, :artist, :art_url, :spotify_id))
    @song.user << current_user
    redirect_to root_path if @song.save
  end

  private

  def get_songs
    if current_user.label_id
      @label = current_user.label
      @songs = @label.user.includes(:song).map(&:song).flatten.uniq
    else
      @label = nil
      @songs = current_user.song
    end
    return @songs
  end
end
