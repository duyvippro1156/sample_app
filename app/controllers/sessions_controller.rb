class SessionsController < ApplicationController
  def new
    redirect_to user_path id: current_user.id if logged_in?
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    return login_fail unless
      user&.authenticate params[:session][:password]

    if user.activated?
      log_in user
      remember user
      redirect_back_or user
    else
      flash[:warning] = t("sessions.not_activated")
      redirect_to login_path
    end
  end
end
