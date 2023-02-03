class SongController < ApplicationController
  before_action :authenticate_user!

  def index
    @song = Song.find(params[:id])
  end

  def create
    song_params =
      params.permit(:name, :artist, :art_url, :icon_url, :spotify_id)
    song =
      Song.find_or_create_by(spotify_id: song_params[:spotify_id]) do |song|
        song.attributes = song_params
      end

    if song.save
      if current_user.label_id
        label = Label.find(current_user.label_id)
        if !label.song_ids.include?(song.id)
          tracked_song =
            TrackedSong.create(
              label_id: current_user.label_id,
              user_id: current_user.id,
              song_id: song.id,
            )
        else
          tracked_song = TrackedSong.find_by(song_id: song.id)
        end
      else
        tracked_song =
          TrackedSong.find_or_create_by(
            song_id: song.id,
            user_id: current_user.id,
          ) do |tracked_song|
            tracked_song.attributes = {
              song_id: song.id,
              user_id: current_user.id,
            }
          end
      end

      if tracked_song.save
        broadcast_receiver =
          (
            if current_user.label_id
              "label_leaderboard_#{current_user.label_id}"
            else
              "user_leaderboard_#{current_user.id}"
            end
          )

        Turbo::StreamsChannel.broadcast_append_to(
          broadcast_receiver,
          target: "table",
          partial: "songs/song",
          locals: {
            song: song,
            user: current_user,
          },
        )

        ChartmetricStreamJob.perform_later(song, current_user)
        redirect_to root_path
      end
    end
  end

  def update
  end

  def remove
    tracked_song = TrackedSong.find_by(song_id: params[:id])
    if TrackedSong.delete(tracked_song)
      broadcast_receiver =
        (
          if current_user.label_id
            "label_leaderboard_#{current_user.label_id}"
          else
            "user_leaderboard_#{current_user.id}"
          end
        )
      Turbo::StreamsChannel.broadcast_remove_to(
        broadcast_receiver,
        target: "song_#{params[:id]}",
      )
    end
    redirect_to root_path, notice: "Song removed from your collection"
  end
end
