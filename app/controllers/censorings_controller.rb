class CensoringsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.censor(params[:tag])

    render partial: 'settings/renew_modal_tags', locals: {tags: current_user.censored_tags}
  end

  def destroy
    current_user.uncensor(params[:tag])

    render partial: 'settings/renew_modal_tags', locals: {tags: current_user.censored_tags}
  end
end
