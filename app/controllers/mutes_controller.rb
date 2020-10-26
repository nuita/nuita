class MutesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(url_digest: params[:user])
    current_user.mute(user)
    flash[:success] = 'このユーザーをミュートしました'
    if request.xhr?
      head :no_content
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    user = User.find_by(url_digest: params[:user])
    current_user.unmute(user)
    flash[:success] = 'ミュートを解除しました'
    if request.xhr?
      head :no_content
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
