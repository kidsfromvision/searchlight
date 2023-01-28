class SongController < ApplicationController
  before_action :authenticate_user!

  def index
    @song = Song.find(params[:id])
  end

  def create
    song_params = params.permit(:name, :artist, :art_url, :icon_url, :spotify_id)
    @song = Song.find_or_create_by(spotify_id:song_params[:spotify_id]) do |song|
      song.attributes = song_params
    end
    @song.user << current_user
    if @song.save
      ChartmetricStreamJob.perform_later(@song)
      Turbo::StreamsChannel.broadcast_append_to(
        "leaderboard",
        target: "table",
        partial: "songs/song",
        locals: {
          song: @song,
        },
      )
      redirect_to root_path
    end
  end

  def remove
    @song = Song.find(params[:id])
    if current_user.song.delete(@song)
      Turbo::StreamsChannel.broadcast_remove_to(
        "leaderboard",
        target: "song_#{@song.id}",
      )
    end
    redirect_to root_path, notice: "Song removed from your collection"
  end
end
