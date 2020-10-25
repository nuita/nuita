class MutesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(url_digest: params[:user])
    current_user.mute(user)
    if request.xhr?
      head :no_content
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    user = User.find_by(url_digest: params[:user])
    current_user.unmute(user)
    if request.xhr?
      head :no_content
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
