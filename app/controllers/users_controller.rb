class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :current_user_admin, only: :destroy

  def index
    @users = User.page(params[:page]).per(Settings.show_limit.show_5)
  end

  def new
    @user = User.new
  end

  def show
    # @user = User.find_by id: params[:id]
    # return if @user

    # flash[:warning] = t "users.user_not_found"
    # redirect_to new_user_path
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      # @user.send_activation_email
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "users.check_email_activated"
      redirect_to login_path
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "users.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "users.deleted"
    else
      flash[:danger] = "users.delete_fail"
    end
    redirect_to @user
  end

  private

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "users.user_not_found"
    redirect_to new_user_path
  end

  def current_user_admin
    redirect_to(root_url) unless current_user.admin?
  end
end
