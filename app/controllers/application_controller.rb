class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  USER_PER_PAGE = 20
  NWEET_PER_PAGE = 10

  def tweet(content)
    return if content.blank?

    current_user.tweet(content)
  rescue StandardError
    flash[:warning] = t('toasts.tweet.failed')
  end

  protected

    # strong parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:handle_name, :screen_name, :icon])
      devise_parameter_sanitizer.permit(:account_update, keys: [:handle_name, :screen_name, :icon, :autotweet_enabled, :autotweet_content, :biography])
    end

    def render_nweets(nweets, query)
      @feed_items = nweets.relations_included.limit(NWEET_PER_PAGE)

      if params[:before]
        date = Time.zone.at(params[:before].to_i)
        @feed_items = @feed_items.where(query, date)
      end

      # 遅延評価のためfeed_itemsが確定してから算出
      @before = @feed_items.last&.did_at&.to_i

      render partial: 'nweets/nweets' if params[:before]
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
