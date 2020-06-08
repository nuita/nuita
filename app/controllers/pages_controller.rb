class PagesController < ApplicationController
  def home
    if user_signed_in?
      @nweet = current_user.nweets.build
      @timeline = true

      if params[:before]
        date = Time.at(params[:before].to_i)
        @feed_items = current_user.timeline.where('did_at < ?', date).limit(10)
        @before = @feed_items.last&.did_at.to_i
        render partial: 'nweets/nweets'
      else
        @feed_items = current_user.timeline.limit(10)
        @before = @feed_items.last&.did_at.to_i
      end
    end
  end

  def about
  end
end
