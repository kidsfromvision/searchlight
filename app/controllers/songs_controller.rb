class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    @label = user_label
    @songs = current_songs
  end

  def archives
    @label = user_label
    @songs = archived_songs
  end

  def list
    if params[:column] == "daily_streams"
      songs =
        current_songs.sort_by do |song|
          (song.recent_daily_streams / song.stream_gap_days).to_i
        end
      songs = songs.reverse if params[:direction] == "asc"
    elsif params[:column] == "added_by" # only happens if the user is part of a label
      songs =
        current_songs.includes(tracked_songs: :user).order(
          "users.name #{params[:direction]}",
        )
    elsif params[:column] == "status"
      songs =
        current_songs.includes(:tracked_songs).order(
          "tracked_songs.status #{params[:direction]}",
        )
    else
      songs = current_songs.order("#{params[:column]} #{params[:direction]}")
    end

    render(partial: "songs/songs", locals: { songs: songs })
  end

  private

  def filter_params
    params.permit(:name, :column, :direction)
  end

  def user_label
    current_user.label
  end

  def current_songs
    @current_songs ||=
      (
        if user_label.nil?
          current_user.songs.where(
            id:
              TrackedSong.select(:song_id).where(
                user_id: user_id,
                archived: false,
              ),
          )
        else
          user_label.songs.where(
            id:
              TrackedSong.select(:song_id).where(
                label_id: user_label.id,
                archived: false,
              ),
          )
        end
      )
  end

  def archived_songs
    @archived_songs ||=
      (
        if user_label.nil?
          current_user.songs.where(
            id:
              TrackedSong.select(:song_id).where(
                user_id: user_id,
                archived: true,
              ),
          )
        else
          user_label.songs.where(
            id:
              TrackedSong.select(:song_id).where(
                label_id: user_label.id,
                archived: true,
              ),
          )
        end
      )
  end
end
