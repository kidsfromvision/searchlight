class AdminToolsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  def update_songs
    ChartmetricAllStreamsJob.perform_now
    render(partial: "admin_tools/update_songs_button")
  end

  private

  def require_admin
    unless current_user.label_id == 1 || current_user.label_id == 2
      redirect_to root_path
    end
  end
end
