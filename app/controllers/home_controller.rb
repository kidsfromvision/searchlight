class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.label_id
      @label = current_user.label
      @songs = @label.user.includes(:song).map(&:song).flatten.uniq
    else
      @label = nil
      @songs = current_user.song
    end
  end
end
