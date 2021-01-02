class User < ApplicationRecord
  before_create :set_url_digest
  after_commit :set_default_censoring, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #:confirmable, :lockable, :timeoutable,
  #:omniauthable, omniauth_providers: [:twitter]

  enum feed_scope: [:followees, :global]

  has_many :nweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_nweets, through: :likes, source: :nweet
  mount_uploader :icon, IconUploader

  validates :screen_name, presence: true, uniqueness: {case_sensitive: false}, length: {maximum: 20}
  validates :screen_name, format: {with: /[0-9a-zA-Z_]/}
  validates :handle_name, length: {maximum: 30}
  validates :biography, length: {maximum: 30}

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followees, -> { order('relationships.created_at DESC') }, through: :active_relationships
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy
  has_many :followers, -> { order('relationships.created_at DESC') }, through: :passive_relationships

  has_many :mutes, foreign_key: 'muter_id', dependent: :destroy
  has_many :muted_users, -> { order('mutes.created_at DESC') }, through: :mutes, source: :mutee

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'origin_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'destination_id', dependent: :destroy

  has_many :censorings, -> { where context: Preference.contexts[:censoring] }, class_name: 'Preference', dependent: :destroy
  has_many :censored_tags, through: :censorings, source: :tag

  has_many :preferrings, -> { where context: Preference.contexts[:preferring] }, class_name: 'Preference', dependent: :destroy
  has_many :preferred_tags, through: :preferrings, source: :tag

  has_and_belongs_to_many :badges

  def timeline
    case feed_scope
    when 'followees'
      followees_feed
    when 'global'
      global_feed
    end
  end

  def followees_feed
    Nweet.includes(links: :tags).references(links: :tags)
      .where('user_id IN (?) OR user_id = ? OR tags.id IN (?)', followee_ids, id, preferred_tag_ids)
      .where.not(user_id: muted_user_ids)
  end

  def global_feed
    Nweet.where.not(user_id: muted_user_ids)
  end

  def nweets_at_date(date)
    nweets.where(did_at: date.beginning_of_day...date.end_of_day).reorder(did_at: :asc)
  end

  def to_param
    url_digest
  end

  def add_twitter_account(auth)
    update(
      twitter_url: auth.info.urls.Twitter,
      twitter_uid: auth.uid,
      twitter_screen_name: auth.info.nickname,
      twitter_access_token: auth.credentials.token,
      twitter_access_secret: auth.credentials.secret
    )
  end

  def delete_twitter_account
    update(
      twitter_url: nil,
      twitter_uid: nil,
      twitter_screen_name: nil,
      twitter_access_token: nil,
      twitter_access_secret: nil,
      autotweet_enabled: false
    )
  end

  def tweet(content)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter[:api_key]
      config.consumer_secret = Rails.application.credentials.twitter[:api_secret]
      config.access_token = twitter_access_token
      config.access_token_secret = twitter_access_secret
    end

    client.update(content)
  end

  def follow(other_user)
    followees << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followee_id: other_user).destroy
  end

  def followee?(other_user)
    followees.include?(other_user)
  end

  def follower?(other_user)
    followers.include?(other_user)
  end

  def mute(other_user)
    muted_users << other_user
  end

  def unmute(other_user)
    mutes.find_by(mutee_id: other_user).destroy
  end

  def muted?(other_user)
    muted_users.include?(other_user)
  end

  # censor, uncensor, censoring? can take both instances of String and Tag
  def censor(tag)
    return if censoring?(tag)

    tag = Tag.find_or_create_by(name: tag.upcase) unless tag.instance_of?(Tag)
    censored_tags << tag
  end

  def uncensor(tag)
    return unless censoring?(tag)

    tag = Tag.find_or_create_by(name: tag.upcase) unless tag.instance_of?(Tag)
    censorings.find_by(tag_id: tag.id).destroy
  end

  def censoring?(tag)
    tag_name = tag.respond_to?(:name) ? tag.name : tag

    censored_tags.exists?(name: tag_name)
  end

  def censoring_tags?(tags)
    tag_names = tags.map do |tag|
      tag.respond_to?(:name) ? tag.name : tag
    end

    censored_tags.pluck(:name) & tag_names
  end

  def prefer(tag)
    return if preferring?(tag)

    tag = Tag.find_or_create_by(name: tag.upcase) unless tag.instance_of?(Tag)
    preferred_tags << tag
  end

  def disprefer(tag)
    return unless preferring?(tag)

    tag = Tag.find_or_create_by(name: tag.upcase) unless tag.instance_of?(Tag)
    preferrings.find_by(tag_id: tag.id).destroy
  end

  def preferring?(tag)
    tag_name = tag.respond_to?(:name) ? tag.name : tag

    preferred_tags.exists?(name: tag_name)
  end

  def preferring_tags?(tags)
    tag_names = tags.map do |tag|
      tag.respond_to?(:name) ? tag.name : tag
    end

    preferred_tags.pluck(:name) & tag_names
  end

  def add_badge(badge)
    # バッジは名前で指定することなくない？
    badges << badge
  end

  def liked?(nweet)
    likes.exists?(nweet_id: nweet.id)
  end

  def check_notifications
    passive_notifications.update_all(checked: true)
  end

  def announce(statement)
    passive_notifications.create(action: :announce, statement: statement)
  end

  class << self
    def screen_name_formatter(str)
      str.gsub(/\W/, '_')[0...20]
    end
  end

  private

    def set_url_digest
      self.url_digest = SecureRandom.alphanumeric
    end

    def set_default_censoring
      Tag.where(censored_by_default: true).each do |tag|
        censor(tag)
      end
    end
end
