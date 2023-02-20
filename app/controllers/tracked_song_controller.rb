class TrackedSongController < ApplicationController
  before_action :authenticate_user!
  include ActionView::Helpers::UrlHelper

  def index
    tracked_song = TrackedSong.find_by(id: params[:id])

    @tracked_song = user_has_permissions(tracked_song) ? tracked_song : nil
  end

  def update
    tracked_song = TrackedSong.find_by(id: params[:id])
    if tracked_song && user_has_permissions(tracked_song)
      tracked_song.update(tracked_song_params)
      tracked_song.broadcast_replace(current_user) if tracked_song.save
    end
  end

  def archive
    tracked_song = TrackedSong.find_by(id: params[:id])
    tracked_song.archived = true
    if tracked_song.save
      tracked_song.broadcast_remove(current_user)
      redirect_to root_path
    end
  end

  def unarchive
    tracked_song = TrackedSong.find_by(id: params[:id])
    tracked_song.archived = false
    if tracked_song.save
      tracked_song.broadcast_add(current_user)
      redirect_to root_path
    end
  end

  def remove
    tracked_song = TrackedSong.find_by(id: params[:id])
    if TrackedSong.delete(tracked_song)
      tracked_song.broadcast_remove(current_user)
    end

    redirect_to root_path
  end

  private

  def tracked_song_params
    params.require(:tracked_song).permit(:is_pinned, :status)
  end

  def user_has_permissions(tracked_song)
    return false unless tracked_song

    is_correct_user = current_user.id == tracked_song.user_id
    is_correct_label(tracked_song) || is_correct_user
  end

  def is_correct_label(tracked_song)
    return false unless tracked_song&.label_id

    current_user&.label_id == tracked_song.label_id
  end
end
