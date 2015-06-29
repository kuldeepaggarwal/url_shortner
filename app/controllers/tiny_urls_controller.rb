class TinyUrlsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_to_after_sign_in_path, if: :user_signed_in?, only: :new

  layout false, only: :create

  def translate
    tiny_url = TinyUrl.find_slug(params[:slug])
    if tiny_url
      redirect_to tiny_url.url, status: 301
    else
      flash[:alert] = 'No url found'
      redirect_to root_path
    end
  end

  def new; end

  def create
    @tiny_url = (current_user || GuestUser.new).build_tiny_url(resource_params)
    if @tiny_url.save
      render partial: 'tiny_url', locals: { tiny_url: @tiny_url }, status: 200
    else
      render partial: 'form', status: :unprocessable_entity
    end
  end

  private

    def resource_params
      params.require(:tiny_url).permit(:url)
    end

    def redirect_to_after_sign_in_path
      flash.keep
      redirect_to after_sign_in_path_for(current_user)
    end
end
