class LikesController < ApplicationController
  def create
    nweet = Nweet.find_by(url_digest: params[:nweet])
    @like = current_user.likes.create(nweet_id: nweet.id)

    render partial: 'nweets/renew_like_form', locals: {nweet: nweet}
  end

  def destroy
    nweet = Nweet.find_by(url_digest: params[:nweet])
    @like = Like.find_by(nweet_id: nweet.id, user_id: current_user.id)
    @like.destroy

    render partial: 'nweets/renew_like_form', locals: {nweet: nweet}
  end
end
