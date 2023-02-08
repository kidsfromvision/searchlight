class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    @label = current_user.label
    @songs = @label.nil? ? current_user.songs : @label.songs
  end

  def list
    label = current_user.label
    songs = label.nil? ? current_user.songs : label.songs

    if params[:column] == "streams"
      songs = songs.sort_by { |song| song.recent_daily_streams }
      songs = songs.reverse if params[:direction] == "asc"
    elsif params[:column] == "added_by" # only happens if the user is part of a label
      songs =
        songs.includes(tracked_songs: :user).order(
          "users.name #{params[:direction]}",
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
end
