class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    label = Label.find(current_user.label_id)
    @label_users = label.users
  end

  private

  def require_admin
    unless current_user.role == "label_admin"
      redirect_to root_path,
                  alert: "You are not authorized to access this page."
    end
  end
end
