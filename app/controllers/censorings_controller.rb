class CensoringsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.censor(params[:tag])

    renew_tags_form
  end

  def destroy
    current_user.uncensor(params[:tag])

    renew_tags_form
  end

  private

    def renew_tags_form
      render partial: 'settings/renew_tags_form', locals: {context: 'censoring', tags: current_user.censored_tags}
    end
end
