class MutesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(url_digest: params[:mutee])
    current_user.mute(user)
    flash[:success] = t('toasts.mute.create')
    if request.xhr?
      head :no_content
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    user = User.find_by(url_digest: params[:mutee])
    current_user.unmute(user)
    flash[:success] = t('toasts.mute.delete')
    if request.xhr?
      head :no_content
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
