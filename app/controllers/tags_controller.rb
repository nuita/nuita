class TagsController < ApplicationController
  before_action :authenticate_user!

  def create
    link = Link.find(params[:link_id])
    link.set_tag(params[:tag_name])

    redirect_back(fallback_location: root_path)
  end

  def destroy
    link = Link.find(params[:link_id])
    link.remove_tag(params[:tag_name])

    redirect_back(fallback_location: root_path)
  end
end
