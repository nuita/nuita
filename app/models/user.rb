class User < ApplicationRecord
  before_create :set_url_digest
  after_create :set_default_censoring

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         #:confirmable, :lockable, :timeoutable #,
         #:omniauthable, omniauth_providers: [:twitter]

  has_many :nweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_nweets, through: :likes, source: :nweet
  mount_uploader :icon, IconUploader

  validates :screen_name, presence: true, uniqueness: true, length: {maximum: 20}
  validates :screen_name, format: {with: /[0-9a-zA-Z_]/}
  validates :handle_name, length: {maximum: 30}
  validates :biography, length: {maximum: 30}

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followees, through: :active_relationships
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy
  has_many :followers, through: :passive_relationships

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'origin_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'destination_id', dependent: :destroy

  has_many :censorings, class_name: 'Preference', dependent: :destroy
  has_many :censored_tags, through: :censorings, source: :tag

  has_and_belongs_to_many :badges
  
  # list nweets shown in timeline.
  def timeline
    Nweet.all # currently it is global! (since FF is not implemented)
  end

  def nweets_at_date(date)
    nweets.where(did_at: date.beginning_of_day...date.end_of_day).reorder(did_at: :asc)
  end

  def to_param
    url_digest
  end

  def add_twitter_account(auth)
    self.update_attributes(
      twitter_url: auth.info.urls.Twitter,
      twitter_uid: auth.uid,
      twitter_screen_name: auth.info.nickname,
      twitter_access_token: auth.credentials.token,
      twitter_access_secret: auth.credentials.secret
    )
  end

  def delete_twitter_account
    self.update_attributes(
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
      config.access_token = self.twitter_access_token
      config.access_token_secret = self.twitter_access_secret
    end

    client.update(content)
  end

  def follow(other_user)
    self.followees << other_user
  end

  def unfollow(other_user)
    self.active_relationships.find_by(followee_id: other_user).destroy
  end

  def followee?(other_user)
    self.followees.include?(other_user)
  end

  def follower?(other_user)
    self.followers.include?(other_user)
  end

  # censor, uncensor, censoring? can take both instances of String and Tag
  def censor(tag)
    if tag.instance_of?(String)
      tag = Tag.find_by(name: tag)
    end

    self.censored_tags << tag
  end

  def uncensor(tag)
    if tag.instance_of?(String)
      tag = Tag.find_by(name: tag)
    end

    self.censorings.find_by(tag_id: tag.id).destroy
  end

  def add_badge(badge)
    # バッジは名前で指定することなくない？
    self.badges << badge
  end

  def censoring?(tag)
    if tag.instance_of?(Tag)
      tag = tag.name
    end

    self.censored_tags.exists?(name: tag)
  end

  def liked?(nweet)
    self.likes.exists?(nweet_id: nweet.id)
  end

  def check_notifications
    self.passive_notifications.update_all(checked:true)
  end

  def announce(statement)
    self.passive_notifications.create(action: :announce, statement: statement)
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
        self.censor(tag)
      end
    end
end
