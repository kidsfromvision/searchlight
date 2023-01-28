class UserSongsController < ApplicationController
  def update
    user_song = UserSong.find(params[:id])
    user_song.update(user_song_params)
  end

  private

  def user_song_params
    params.require(:user_song).permit(:is_pinned, :status)
  end
end
