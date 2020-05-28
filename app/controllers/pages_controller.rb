class PagesController < ApplicationController
  def home
    if user_signed_in?
      @nweet = current_user.nweets.build
      @timeline = true

      if params[:before]
        @before = Nweet.find_by(url_digest: params[:before])
        @feed_items = current_user.timeline.where('did_at < ?', @before.did_at).limit(10)
        render partial: 'nweets/nweet', collection: @feed_items
      else
        @feed_items = current_user.timeline.limit(10)
      end
    end
  end

  def about
  end
end
