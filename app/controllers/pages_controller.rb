class PagesController < ApplicationController
  def home
    if user_signed_in?
      if params[:success] == 'true'
        @nweet = Nweet.find_by(url_digest: params[:url_digest])
      else
        @nweet = current_user.nweets.build
      end
      @feed_items = current_user.timeline.paginate(page: params[:page])
      @timeline = true
    end
  end

  def likes
    @feed_items = current_user.liked_nweets.paginate(page: params[:page])
  end

  def about
  end
end
