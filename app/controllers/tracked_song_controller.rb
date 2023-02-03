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
      song = Song.find_by(id: tracked_song.song_id)
      success = tracked_song.save if song
      if success
        broadcast_receiver =
          (
            if current_user.label_id
              "label_leaderboard_#{current_user.label_id}"
            else
              "user_leaderboard_#{current_user.id}"
            end
          )
        Turbo::StreamsChannel.broadcast_replace_to(
          broadcast_receiver,
          target: "song_#{song.id}",
          partial: "songs/song",
          locals: {
            song: song,
            user: current_user,
          },
        )
      end
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
