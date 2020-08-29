class PreferringsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.prefer(params[:tag])

    renew_tags_form
  end

  def destroy
    current_user.disprefer(params[:tag])

    renew_tags_form
  end

  private

    def renew_tags_form
      render partial: 'settings/renew_tags_form', locals: {context: :preferring}
    end
end
