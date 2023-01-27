class SongController < ApplicationController
  before_action :authenticate_user!

  def index
    @song = Song.find(params[:id])
  end

  def create
    @song =
      Song.new(params.permit(:name, :artist, :art_url, :icon_url, :spotify_id))
    @song.user << current_user
    if @song.save
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
end
