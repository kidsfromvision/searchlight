class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.label_id
      @label = current_user.label
      @songs = @label.song
    else
      @label = nil
      @songs = current_user.song
    end
  end
end
