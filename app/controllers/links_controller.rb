require 'open-uri'
require 'nokogiri'

class LinksController < ApplicationController
  def recommend
    tag_editable = true if user_signed_in?
    
    render partial: 'cards/horizontal', locals: {link: Link.recommend(displayable: params[:displayable]), genre_hidden?: !tag_editable}
  end
end
