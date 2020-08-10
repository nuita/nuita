class PagesController < ApplicationController
  def home
    if user_signed_in?
      @nweet = current_user.nweets.build
      @timeline = true

      render_nweets(current_user.timeline, 'did_at < ?')
    end
  end

  def about
  end

  def explore
    @timeline = true

    render_nweets(Nweet.global_feed, 'did_at < ?')
  end
end
