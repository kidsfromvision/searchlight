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
end
