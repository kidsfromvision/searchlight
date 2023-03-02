class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_label, only: %i[label label_archives]

  def index
    @label = user_label
    @songs = user_songs
  end

  def label
    @label = user_label
    @songs = label_songs
  end

  def archives
    @songs = user_archived_songs
  end

  def label_archives
    @songs = label_archived_songs
  end

  def list
    render(
      partial: "songs/songs",
      locals: {
        songs: sort_songs(user_songs, params),
        is_label: false,
      },
    )
  end

  def label_list
    render(
      partial: "songs/songs",
      locals: {
        songs: sort_songs(label_songs, params),
        is_label: true,
      },
    )
  end

  private

  def filter_params
    params.permit(:name, :column, :direction)
  end

  def user_label
    current_user.label
  end

  def user_songs
    @user_songs ||=
      current_user.songs.where(
        id:
          TrackedSong.select(:song_id).where(
            user_id: current_user.id,
            archived: false,
          ),
      )
  end

  def label_songs
    @label_songs ||=
      user_label.songs.where(
        id:
          TrackedSong.select(:song_id).where(
            label_id: user_label.id,
            archived: false,
          ),
      )
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

  def label_archived_songs
    @label_archived_songs ||=
      user_label.songs.where(
        id:
          TrackedSong.select(:song_id).where(
            label_id: user_label.id,
            archived: true,
          ),
      )
  end

  def user_archived_songs
    @user_archived_songs ||=
      current_user.songs.where(
        id:
          TrackedSong.select(:song_id).where(
            user_id: current_user.id,
            archived: true,
          ),
      )
  end

  def require_label
    redirect_to root_path unless current_user.label_id.present?
  end

  def sort_songs(current_songs, params)
    if params[:column] == "daily_streams"
      songs =
        current_songs.sort_by do |song|
          if song.recent_daily_streams.nil? || song.stream_gap_days.nil?
            0
          else
            (song.recent_daily_streams / song.stream_gap_days).to_i
          end
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
    songs
  end
end
