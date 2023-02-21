class SongController < ApplicationController
  before_action :authenticate_user!

  def index
    @song = Song.find(params[:id])
  end

  def create
    song =
      Song.find_or_create_by(spotify_id: song_params[:spotify_id]) do |song|
        song.attributes = song_params
      end

    raise "Song failed to save" unless song.save

    tracked_song =
      TrackedSong.find_or_create_by(
        tracked_song_search_params(song.id),
      ) do |tracked_song|
        tracked_song.attributes = tracked_song_create_params(song.id)
      end

    raise "Tracked song failed to save" unless tracked_song.save

    tracked_song.broadcast_add(current_user)
    ChartmetricSingleStreamsJob.perform_later(song)
    ChartmetricGenresJob.perform_later(song)
    redirect_to root_path
  end

  private

  def tracked_song_search_params(song_id)
    if current_user.label_id
      { label_id: current_user.label_id, song_id: song_id }
    else
      { song_id: song_id, user_id: current_user.id }
    end
  end

  def tracked_song_create_params(song_id)
    if current_user.label_id
      {
        label_id: current_user.label_id,
        song_id: song_id,
        user_id: current_user.id,
      }
    else
      { song_id: song_id, user_id: current_user.id }
    end
  end

  def song_params
    @song_params ||=
      params.permit(
        :name,
        :artist,
        :artist_id,
        :art_url,
        :icon_url,
        :spotify_id,
        :released,
      )
  end
end
