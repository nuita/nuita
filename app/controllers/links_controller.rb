require 'open-uri'
require 'nokogiri'

class LinksController < ApplicationController
  def recommend
    # レイアウトを一新するまでの仮のルーティング、後にNweetController#recommendへ移動
    nweet = Nweet.recommend
    render partial: 'cards/card', locals: {link: nweet.links.first, genre_hidden?: !user_signed_in?}
  end
end
