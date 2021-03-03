class PagesController < ApplicationController
  def home
    if user_signed_in?
      @nweet = current_user.nweets.build
      @timeline = true

      render_nweets(current_user.timeline, 'did_at < ?')
    else
      @tags = Tag.where(featured: true)
    end
  end

  def about
  end

  def explore
    @timeline = true

    nweets = if params[:q]
      Nweet.search(params[:q])
    else
      current_user&.global_feed || Nweet.global_feed
    end

    render_nweets(nweets, 'did_at < ?')
  end
end
