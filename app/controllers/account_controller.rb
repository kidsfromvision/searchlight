class AccountController < ApplicationController
  def index
  end

  # POST /account/reset_password
  def reset_password
    current_user.send_reset_password_instructions
    render(partial: "account/reset_password_confirmation")
  end
end
