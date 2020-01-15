class UsersController < ApplicationController
  before_action :authenticate_user!, :friend_user, only: [:likes, :followers, :followees]

  def show
    @user = User.find_by(url_digest: params[:url_digest])
    if params[:date]
      @feed_items = @user.nweets_at_date(params[:date].to_time).paginate(page: params[:page])
    else
      @feed_items = @user.nweets.paginate(page: params[:page])
    end

    if params[:scroll]
      render partial: 'nweets/nweet', collection: @feed_items
    end
  end

  def likes
    @user = User.find_by(url_digest: params[:url_digest])
    @feed_items = @user.liked_nweets.paginate(page: params[:page])

    if params[:scroll]
      render partial: 'nweets/nweet', collection: @feed_items
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
