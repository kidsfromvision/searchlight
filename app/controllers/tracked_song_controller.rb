class TrackedSongController < ApplicationController
  def update
    tracked_song = TrackedSong.find(params[:id])
    tracked_song.update(tracked_song_params)
  end

  private

  def tracked_song_params
    params.require(:tracked_song).permit(:is_pinned, :status)
  end
end
