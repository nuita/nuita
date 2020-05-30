class UsersController < ApplicationController
  before_action :authenticate_user!, :friend_user, only: [:likes, :followers, :followees]

  def show
    @user = User.find_by(url_digest: params[:url_digest])

    if params[:date]
      @all_feed_items = @user.nweets_at_date(params[:date].to_time)
      query = 'did_at > ?'
    else
      @all_feed_items = @user.nweets
      query = 'did_at < ?'
    end

    if params[:before]
      @before = Nweet.find_by(url_digest: params[:before])
      @feed_items = @all_feed_items.where(query, @before.did_at).limit(10)
      render partial: 'nweets/nweet', collection: @feed_items
    else
      @feed_items = @all_feed_items.limit(10)
    end
  end

  def likes
    @user = User.find_by(url_digest: params[:url_digest])

    if params[:before]
      @before = Nweet.find_by(url_digest: params[:before])
      @feed_items = @user.liked_nweets.where('did_at < ?', @before.did_at).limit(10)
      render partial: 'nweets/nweet', collection: @feed_items
    else
      @feed_items = @user.liked_nweets.limit(10)
    end
  end

  def followers
    @topic = 'フォロワー'
    @user = User.find_by(url_digest: params[:url_digest])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def followees
    @topic = 'フォロー'
    @user = User.find_by(url_digest: params[:url_digest])
    @users = @user.followees.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def friend_user
      @user = User.find_by(url_digest: params[:url_digest])
      unless @user == current_user || (@user.followee?(current_user) && @user.follower?(current_user))
        redirect_to(user_path(@user))
      end
    end

    def correct_user
      user = User.find_by(url_digest: params[:url_digest])
      unless user == current_user
        redirect_to(new_user_session_url)
      end
    end
end
