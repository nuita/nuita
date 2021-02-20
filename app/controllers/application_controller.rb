class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  USER_PER_PAGE = 20

  def tweet(content = render_tweet(current_user.autotweet_content))
    current_user.tweet(content)
  rescue StandardError
    flash[:warning] = 'ツイートに失敗しました。Twitterアカウントの状態を確認してください。'
  end

  protected

    # strong parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:handle_name, :screen_name, :icon])
      devise_parameter_sanitizer.permit(:account_update, keys: [:handle_name, :screen_name, :icon, :autotweet_enabled, :autotweet_content, :biography])
    end

    def current_user?
      current_user == @user
    end

    # generate content of tweet from user-specific template
    def render_tweet
      current_user.autotweet_content.gsub(/\[LINK\]/, nweet_url(@nweet))
    end

    def render_nweets(nweets, query)
      nweet_limit = 10
      
      if params[:before]
        date = Time.zone.at(params[:before].to_i)
        @feed_items = nweets.relations_included.where(query, date).limit(nweet_limit)
        @before = @feed_items.last&.did_at&.to_i
        render partial: 'nweets/nweets'
      else
        @feed_items = nweets.relations_included.limit(nweet_limit)
        @before = @feed_items.last&.did_at&.to_i
      end
    end

    def render_users(users, template)
      @feed_items = users.paginate(page: params[:page], per_page: USER_PER_PAGE)

      if params[:page]
        @page = params[:page].to_i + 1 if @feed_items.any?
        render partial: 'users/users'
      else
        @page = users.count > USER_PER_PAGE ? 2 : nil
        render template
      end
    end
end
