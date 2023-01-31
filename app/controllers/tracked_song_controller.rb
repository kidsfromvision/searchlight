class TrackedSongController < ApplicationController
  before_action :authenticate_user!

  def update
    tracked_song = TrackedSong.find(params[:id])
    tracked_song.update(tracked_song_params)
    song = Song.find(tracked_song.song_id)

    if tracked_song.save
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

  private

  def tracked_song_params
    params.require(:tracked_song).permit(:is_pinned, :status)
  end
end
