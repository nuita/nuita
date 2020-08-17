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
    users = @user.followers.paginate(page: params[:page])

    render_users(users)
  end

  def followees
    @topic = 'フォロー'
    @user = User.find_by(url_digest: params[:url_digest])
    users = @user.followees.paginate(page: params[:page])

    render_users(users)
  end

  # Update user without password confirmation. 
  def tweak
    current_user.update_attributes(tweak_params)
    
    redirect_back(fallback_location: settings_path)
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

    # Strong parameters. They can be set without password, so be careful.
    def tweak_params
      params.require(:user).permit(:feed_scope)
    end

    def render_users(users)
      @feed_items = users.paginate(page: params[:page])

      if params[:page]
        @page = params[:page].to_i + 1
        render partial: 'users/users'
      else
        @page = 1
        render 'show_follow'
      end
    end
end
