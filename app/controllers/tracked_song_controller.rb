class TrackedSongController < ApplicationController
  before_action :authenticate_user!

  def index
    tracked_song = TrackedSong.find_by(id: params[:id])
    if !tracked_song || !user_has_permissions(tracked_song)
      @song = nil
    else
      @song = Song.find(tracked_song.song_id)
    end
  end

  def update
    tracked_song = TrackedSong.find_by(id: params[:id])
    if tracked_song && user_has_permissions(tracked_song)
      tracked_song.update(tracked_song_params)
      tracked_song.broadcast_replace(current_user) if tracked_song.save
    end
  end

  private

  def tracked_song_params
    params.require(:tracked_song).permit(:is_pinned, :status)
  end

  def user_has_permissions(tracked_song)
    is_correct_label =
      current_user.label_id && current_user.label_id == tracked_song.label_id
    is_correct_user = current_user.id == tracked_song.user_id
    return is_correct_label || is_correct_user
  end
end
