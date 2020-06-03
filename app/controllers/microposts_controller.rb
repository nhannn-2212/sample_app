class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :build_micropost, only: :create

  def create
    if @micropost.save
      flash[:success] = t "success.micropost_created"
      redirect_to root_url
    else
      flash.now[:danger] = t "error.micropost_created"
      @feed_items = current_user.feed.paginate(page: params[:page],
        per_page: Settings.per_page)
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.delete
      flash[:success] = t "success.micropost_deleted"
      redirect_to request.referer || root_url
    else
      flash[:danger] = t "error.micropost_deleted"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:danger] = t "error.invalid_micropost"
    redirect_to root_url
  end

  def build_micropost
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
  end
end
