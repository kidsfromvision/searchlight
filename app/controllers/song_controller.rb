class SongController < ApplicationController
  before_action :authenticate_user!
  before_action :require_label, only: %i[add_tracked_song_to_label]

  def index
    @song = Song.find(params[:id])
  end

  def create
    broadcast_search_result_icon_loading

    artist =
      Artist.find_or_create_by(
        spotify_id: artist_params[:artist_spotify_id],
      ) { |artist| artist.attributes = artist_params }

    raise "Artist failed to save" unless artist.save

    song =
      Song.find_or_create_by(spotify_id: song_params[:spotify_id]) do |song|
        song.attributes = { artist_id: artist.id }.merge(song_params)
      end

    EngineRequestManager.create_artist_metadata(artist.id)

    raise "Song failed to save" unless song.save

    tracked_song =
      TrackedSong.find_or_create_by(
        { song_id: song.id, user_id: current_user.id },
      ) do |tracked_song|
        tracked_song.attributes = { song_id: song.id, user_id: current_user.id }
      end

    raise "Tracked song failed to save" unless tracked_song.save

    broadcast_search_result_icon_loaded

    ChartmetricSingleStreamsJob.perform_later(song)
    ChartmetricGenresJob.perform_later(song)
  end

  private

  def song_params
    @song_params ||=
      params.permit(:name, :art_url, :icon_url, :spotify_id, :released)
  end

  def artist_params
    request_params = params.permit(:artist_name, :artist_spotify_id)
    @artist_params = {
      name: request_params[:artist_name],
      spotify_id: request_params[:artist_spotify_id],
    }
  end

  def require_label
    redirect_to root_path unless current_user.label_id.present?
  end

  def broadcast_search_result_icon_loading
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "search_result_icon_#{song_params[:spotify_id]}",
      partial: "search/search_result_icon_loading",
      locals: {
        spotify_id: song_params[:spotify_id],
      },
    )
  end

  def broadcast_search_result_icon_loaded
    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: "search_result_icon_#{song_params[:spotify_id]}",
      partial: "search/search_result_icon_loaded",
      locals: {
        spotify_id: song_params[:spotify_id],
      },
    )
  end
end
