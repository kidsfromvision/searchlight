class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.label_id
      @label = current_user.label
      @songs = @label.user_song.map(&:song)
    else
      @label = nil
      @songs = current_user.user_songs.map(&:song)
    end
  end
end
