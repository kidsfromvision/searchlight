class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.label_id
      @label = Label.find(current_user.label_id)
      @songs = @label.user.includes(:song).map(&:song).flatten.uniq
    else
      @label = nil
      @songs = user.song
    end
  end
end
