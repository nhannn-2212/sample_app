class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(new index create)
  before_action :correct_user, only: %i(update edit)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.per_page)
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "info.check_email_activation"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.sort_by_created_at.paginate(page: params[:page],
      per_page: Settings.per_page)
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success.update_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success.delete_user"
    else
      flash[:danger] = t "error.delete_user"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    load_user
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t "follower"
    load_user
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    load_user
    return if current_user? @user

    flash[:danger] = t "error.no_permit"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.invalid_ID"
    redirect_to root_url
  end
end
