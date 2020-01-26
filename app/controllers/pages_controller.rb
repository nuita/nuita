class PagesController < ApplicationController
  def home
    if user_signed_in?
      @nweet = current_user.nweets.build
      @feed_items = current_user.timeline.paginate(page: params[:page])
      @timeline = true

      if params[:scroll]
        render partial: 'nweets/nweet', collection: @feed_items
      end
    end
  end

  def about
  end
end
