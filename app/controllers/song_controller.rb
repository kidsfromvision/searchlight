class SongController < ApplicationController
  before_action :authenticate_user!

  def index
    @song = Song.find(params[:id])
  end

  def create
    song_params =
      params.permit(
        :name,
        :artist,
        :artist_id,
        :art_url,
        :icon_url,
        :spotify_id,
      )
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
        tracked_song.broadcast_add(current_user)
        ChartmetricSingleStreamsJob.perform_later(song)
        redirect_to root_path
      end
    end
  end

  def update
  end

  def remove
    tracked_song = TrackedSong.find_by(song_id: params[:id])
    if TrackedSong.delete(tracked_song)
      tracked_song.broadcast_remove(current_user)
    end

    redirect_to root_path
  end
end
