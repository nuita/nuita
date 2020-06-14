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

    render_nweets(@all_feed_items, query)
  end

  def likes
    @user = User.find_by(url_digest: params[:url_digest])

    render_nweets(@user.liked_nweets, 'did_at < ?')
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

    def render_nweets(nweets, query)
      if params[:before]
        date = Time.zone.at(params[:before].to_i)
        @feed_items = nweets.where(query, date).limit(10)
        @before = @feed_items.last&.did_at&.to_i
        render partial: 'nweets/nweets'
      else
        @feed_items = nweets.limit(10)
        @before = @feed_items.last&.did_at&.to_i
      end
    end
end
