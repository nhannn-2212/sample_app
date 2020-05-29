class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user,
                :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, :blank)
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash.now[:success] = t "success.reset_pwd"
      redirect_to @user
    else
      render :edit
    end
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_pwd_reset_email
      flash[:info] = t "info.sent_reset_pwd_email"
      redirect_to root_url
    else
      flash.now[:danger] = t "error.invalid_email"
      render :new
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email].downcase
    return if @user

    flash[:danger] = t "error.invalid_email"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "error.user_inactive"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "link_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
