class AdminController < ApplicationController
  before_action :require_user

  private

  def require_user
    unless user_signed_in?
      flash[:error] = "You aren't authorized to manage content"
      redirect_to new_user_session_path
    end
  end
end
