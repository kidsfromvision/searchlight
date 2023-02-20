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
    songs = current_songs

    if params[:column] == "streams"
      songs = songs.sort_by { |song| song.recent_daily_streams }
      songs = songs.reverse if params[:direction] == "asc"
    elsif params[:column] == "added_by" # only happens if the user is part of a label
      songs =
        songs.includes(tracked_songs: :user).order(
          "users.name #{params[:direction]}",
        )
    elsif params[:column] == "status"
      song =
        songs.includes(tracked_songs).order(
          "tracked_songs.status #{params[:direction]}",
        )
    else
      songs = songs.order("#{params[:column]} #{params[:direction]}")
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
        if @label.nil?
          current_user
            .songs
            .joins(:tracked_songs)
            .where.not(tracked_songs: { archived: true })
        else
          @label
            .songs
            .joins(:tracked_songs)
            .where.not(tracked_songs: { archived: true })
        end
      )
  end

  def archived_songs
    @archived_songs ||=
      (
        if @label.nil?
          current_user
            .songs
            .joins(:tracked_songs)
            .where(tracked_songs: { archived: true })
        else
          @label
            .songs
            .joins(:tracked_songs)
            .where(tracked_songs: { archived: true })
        end
      )
  end
end
