class NweetsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :correct_user, only: [:update, :destroy]

  def new
    @nweet = current_user.nweets.build(did_at: Time.zone.now)
    @feed_items = current_user.timeline.paginate(page: params[:page])
    @timeline = true

    if params[:scroll]
      render partial: 'nweets/nweet', collection: @feed_items
    end
  end

  def create
    @nweet = current_user.nweets.build(new_nweet_params)
    if @nweet.save
      flash[:success] = 'ヌイートを投稿しました！'
      if @nweet.links.any?
        set_tags(@nweet.links.first)
      end
      tweet if current_user.autotweet_enabled
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
    flash[:success] = 'ヌイートを削除しました'
    redirect_to root_url
  end

  # obsolete
  def update
    @nweet = Nweet.find_by(url_digest: params[:url_digest])

    if @nweet.update_attributes(edit_nweet_params)
      flash[:success] = 'ヌイートを更新しました'
      redirect_to root_url
    else
      flash[:danger] = @nweet.errors.full_messages
      redirect_to root_url
    end
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

    def set_tags(link)
      # 正直カテゴリーの中身mass assignmentされても何の脆弱性もないたぶん
      params.permit(tags: {}).to_hash["tags"].each do |tag_name, value|
        link.set_tag(tag_name) if value == '1'
      end
    end
end
