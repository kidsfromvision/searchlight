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
      tracked_song.save
    end
  end

  def archive
    tracked_song = TrackedSong.find_by(id: params[:id])
    if tracked_song && user_has_permissions(tracked_song)
      tracked_song.archived = true
      tracked_song.broadcast_remove if tracked_song.save
      redirect_to root_path
    end
  end

  def unarchive
    tracked_song = TrackedSong.find_by(id: params[:id])
    if tracked_song && user_has_permissions(tracked_song)
      tracked_song.archived = false
      raise "Failed to unarchive song" unless tracked_song.save

      # Calling broadcast methods explicitly here because there's no after_archive_commit hook
      tracked_song.broadcast_add_to_user
      tracked_song.broadcast_add_to_label if tracked_song.label_id
    end

    if tracked_song.label_id
      redirect_to label_leaderboard_path
    else
      redirect_to root_path
    end
  end

  def remove
    tracked_song = TrackedSong.find_by(id: params[:id])
    if tracked_song && user_has_permissions(tracked_song)
      raise "Failed to remove song" unless tracked_song.destroy
    end

    redirect_to root_path
  end

  def add_tracked_song_to_label
    tracked_song = TrackedSong.find_by(id: params[:id])
    if tracked_song && user_has_permissions(tracked_song)
      tracked_song.label_id = current_user.label_id
      raise "Failed to move tracked song to label" unless tracked_song.save
    end

    tracked_song.broadcast_add_to_label
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
