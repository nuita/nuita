class TagsController < ApplicationController
  before_action :authenticate_user!

  def create
    link = Link.find(params[:link])
    link.set_tag(params[:name])

    render partial: 'cards/renew_modal_tags', locals: {link: link}
  end

  def destroy
    link = Link.find(params[:link])
    link.remove_tag(params[:name])

    render partial: 'cards/renew_modal_tags', locals: {link: link}
  end
end
