class NweetsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :recommend]
  before_action :correct_user, only: [:destroy]

  def new
    @nweet = current_user.nweets.build(did_at: Time.zone.now)
    @feed_items = current_user.timeline.paginate(page: params[:page])
    @timeline = true

    if params[:before]
      @before = Nweet.find_by(url_digest: params[:before])
      @feed_items = current_user.timeline.where('did_at < ?', @before.did_at).limit(10)
      render partial: 'nweets/nweet', collection: @feed_items
    else
      @feed_items = current_user.timeline.limit(10)
    end
  end

  def create
    @nweet = current_user.nweets.build(new_nweet_params)
    set_did_at

    if @nweet.save
      flash[:success] = t('toasts.nweet.post')
      tweet(generate_tweet_content(@nweet)) if current_user.autotweet_enabled
    else
      flash[:danger] = @nweet.errors.full_messages
    end

    redirect_to root_url
  end

  def show
    @nweet = Nweet.find_by(url_digest: params[:url_digest])
    @detail = true
  end

  def destroy
    @nweet = Nweet.find_by(url_digest: params[:url_digest])
    @nweet.destroy
    flash[:success] = t('toasts.nweet.delete')
    redirect_to root_url
  end

  def recommend
    render partial: 'nweets/display', locals: {nweet: Nweet.recommend}
  end

  private

    # strong parameters
    def new_nweet_params
      params.require(:nweet).permit(:statement, :did_at)
    end

    def edit_nweet_params
      params.require(:nweet).permit(:statement)
    end

    def correct_user
      @nweet = current_user.nweets.find_by(url_digest: params[:url_digest])
      redirect_to root_url if @nweet.nil?
    end

    # generate content of tweet from user-specific template
    def generate_tweet_content(nweet)
      current_user.autotweet_content.gsub(/\[LINK\]/, nweet_url(nweet))
    end

    # did_atが空か、指定された時刻が現在から3分以内の場合に現在時刻を挿入する
    def set_did_at
      if @nweet.did_at.nil? || @nweet.did_at > 3.minutes.ago
        @nweet.did_at = Time.zone.now
      end
    end
end
