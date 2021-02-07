require 'uri'

class Nweet < ApplicationRecord
  before_create :set_url_digest

  after_save :create_link, :create_tag

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :nweet_links, dependent: :destroy
  has_many :links, through: :nweet_links

  validates :user_id, presence: true
  validates :did_at, presence: true
  validates :statement, length: {maximum: 100}
  validate :past?
  validate :has_enough_interval?, on: :create

  default_scope -> { order(did_at: :desc) }

  scope :included, -> { includes(:user, :nweet_links, links: :tags) }

  self.per_page = 10

  def past?
    if did_at && did_at > Time.zone.now
      errors.add(:did_at, ' is not in the past')
    end
  end

  def has_enough_interval?
    return if user.nweets.count == 0 || did_at.nil?

    if did_at < user.nweets.first.did_at + 3.minutes
      errors.add(:did_at, ' has not enough interval')
    end
  end

  def to_param
    url_digest
  end

  def create_link
    if statement
      URI.extract(statement, ['http', 'https']).uniq.each do |url|
        links << Link.fetch_from(url)
      rescue StandardError
        logger.debug "Creating Link for #{url} has failed."
      end
    end
  end

  def create_tag
    if links.any?
      # 本当は空白に置換したかったけどコールバックの前後関係で無理そう
      statement.scan(/\s#\S*/) do |tag|
        links.each do |link|
          link.set_tag(tag[2..])
        end
      end
    end
  end

  class << self
    def global_feed
      Nweet.all
    end
  end

  private

    def set_url_digest
      self.url_digest = SecureRandom.alphanumeric
    end
end
