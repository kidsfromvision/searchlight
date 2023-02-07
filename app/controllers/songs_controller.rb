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
          song.recent_streams.last.streams - song.recent_streams.first.streams
        end
    elsif params[:column] == "added_by" # only happens if the user is part of a label
      songs =
        songs
          .joins(tracked_songs: :user)
          .where(tracked_songs: { label_id: label.id })
          .order("users.name asc")
    else
      songs = songs.order("#{params[:column]} asc")
    end

    render(partial: "songs/songs", locals: { songs: songs })
  end
end
