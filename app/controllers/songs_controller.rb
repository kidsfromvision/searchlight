class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_label, only: %i[label label_archives]

  def index
    @label = user_label
    @songs = user_songs
  end

  def index_stream
    broadcast_table_loading
    broadcast_personal_table
    broadcast_personal_selected
  end

  def label
    @label = user_label
    @songs = label_songs
  end

  def label_stream
    broadcast_table_loading
    broadcast_label_table
    broadcast_label_selected
  end

  def archives
    @songs = user_archived_songs
  end

  def label_archives
    @songs = label_archived_songs
  end

  private

  def user_label
    current_user.label
  end

  def user_songs
    @user_songs ||=
      current_user
        .songs
        .where(
          id:
            TrackedSong.select(:song_id).where(
              user_id: current_user.id,
              archived: false,
            ),
        )
        .sort_by do |song|
          if song.recent_daily_streams.nil? || song.stream_gap_days.nil?
            0
          else
            (song.recent_daily_streams / song.stream_gap_days).to_i
          end
        end
        .reverse
  end

  def label_songs
    @label_songs ||=
      user_label
        .songs
        .where(
          id:
            TrackedSong.select(:song_id).where(
              label_id: user_label.id,
              archived: false,
            ),
        )
        .sort_by do |song|
          if song.recent_daily_streams.nil? || song.stream_gap_days.nil?
            0
          else
            (song.recent_daily_streams / song.stream_gap_days).to_i
          end
        end
        .reverse
  end

  def current_songs
    @current_songs ||=
      (if user_label.nil?
        current_user.songs.where(
          id: TrackedSong.select(:song_id).where(
            user_id: user_id,
            archived: false,
          ),
        )
      else
        user_label.songs.where(
          id: TrackedSong.select(:song_id).where(
            label_id: user_label.id,
            archived: false,
          ),
        )
      end)
  end

  def label_archived_songs
    @label_archived_songs ||=
      user_label.songs.where(
        id: TrackedSong.select(:song_id).where(
          label_id: user_label.id,
          archived: true,
        ),
      )
  end

  def user_archived_songs
    @user_archived_songs ||=
      current_user.songs.where(
        id: TrackedSong.select(:song_id).where(
          user_id: current_user.id,
          archived: true,
        ),
      )
  end

  def require_label
    redirect_to root_path unless current_user.label_id.present?
  end

  def broadcast_label_selected
    Turbo::StreamsChannel.broadcast_replace_later_to(
      current_user,
      target: "leaderboard_selector",
      partial: "songs/leaderboard_selector",
      locals: {
        is_label: true,
        path: root_stream_path,
      },
    )
  end

  def broadcast_personal_selected
    Turbo::StreamsChannel.broadcast_replace_later_to(
      current_user,
      target: "leaderboard_selector",
      partial: "songs/leaderboard_selector",
      locals: {
        is_label: false,
        path: label_leaderboard_stream_path,
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
        user: current_user,
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
        user: current_user,
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
        user: current_user,
      },
    )
  end

  def broadcast_table_loading
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "leaderboard_table",
      partial: "songs/songs_loading",
      locals: {
        is_label: !user_label.present?,
      },
    )
  end
end
