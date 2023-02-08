class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.label_id
      @label = current_user.label
      @songs = @label.songs
    else
      @label = nil
      @songs = current_user.songs
    end
  end

  def list
    if current_user.label_id
      label = current_user.label
      songs = label.songs
    else
      label = nil
      songs = current_user.songs
    end
    if params[:column] == "streams"
      songs =
        songs.sort_by do |song|
          if params[:direction] == "asc"
            song.recent_streams.last.streams - song.recent_streams.first.streams
          else
            song.recent_streams.first.streams - song.recent_streams.last.streams
          end
        end
    elsif params[:column] == "added_by" # only happens if the user is part of a label
      songs =
        songs
          .joins(tracked_songs: :user)
          .where(tracked_songs: { label_id: label.id })
          .order("users.name #{params[:direction]}")
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
