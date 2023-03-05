class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_label, only: %i[label label_archives]

  def index
    @label = user_label
    @songs = user_songs
  end

  def index_stream
    broadcast_personal_selected
    broadcast_personal_table
  end

  def label
    @label = user_label
    @songs = label_songs
  end

  def label_stream
    broadcast_label_selected
    broadcast_label_table
  end

  def archives
    @songs = user_archived_songs
  end

  def label_archives
    @songs = label_archived_songs
  end

  def list_streams
    broadcast_sorted_table(is_label: false)
  end

  def label_list_streams
    broadcast_sorted_table(is_label: true)
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

  def broadcast_label_selected
    Turbo::StreamsChannel.broadcast_replace_later_to(
      current_user,
      target: "page_head",
      partial: "shared/page_head",
      locals: {
        selected_title: "Label",
        path: root_stream_path,
        is_archives: false, 
        hide_search: false, 
        title: "Leaderboard", 
        hide_selector: false,
        user: current_user,
      },
    )
  end

  def broadcast_personal_selected
    Turbo::StreamsChannel.broadcast_replace_later_to(
      current_user,
      target: "page_head",
      partial: "shared/page_head",
      locals: {
        selected_title: "Personal",
        path: label_leaderboard_stream_path,
        is_archives: false, 
        hide_search: false, 
        title: "Leaderboard", 
        hide_selector: false,
        user: current_user,
      },
    )
  end

  def broadcast_label_table
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "leaderboard_table",
      partial: "songs/songs",
      locals: {
        songs: label_songs, 
        is_label: true,
        user: current_user
      },
    )
  end

  def broadcast_personal_table
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "leaderboard_table",
      partial: "songs/songs",
      locals: {
        songs: user_songs,
        is_label: false,
        user: current_user
      },
    )
  end

  def broadcast_sorted_table(is_label:)
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "leaderboard_table",
      partial: "songs/songs",
      locals: {
        songs: sort_songs(is_label ? label_songs : user_songs, params),
        is_label: is_label,
        user: current_user
      },
    )
  end

end
