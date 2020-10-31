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
  validate :did_at_past?
  validate :have_enough_interval?, on: :create
  validate :statement_under_max_length?

  default_scope -> { order(did_at: :desc) }

  scope :included, -> { includes(:user, :nweet_links, links: :tags) }

  self.per_page = 10

  def did_at_past?
    if did_at # did at is not nil
      errors.add(:did_at, " is not in the past") unless did_at <= Time.zone.now
    end
  end

  # may need refactoring
  def have_enough_interval?
    if user.nweets.count != 0 && did_at && did_at < user.nweets.first.did_at + 3.minutes
      errors.add(:did_at, " has not enough interval")
    end
  end

  def create
  end

  def to_param
    url_digest
  end

  def create_link
    if self.statement
      URI.extract(self.statement, ['http', 'https']).uniq.each do |url|
        begin
          self.links << Link.fetch_from(url)
        rescue
          logger.debug "Creating Link for #{url} has failed."
        end
      end
    end
  end

  def create_tag
    if links.any?
      # 本当は空白に置換したかったけどコールバックの前後関係で無理そう
      self.statement.scan(/\s#\S*/) do |tag|
        links.each do |link|
          link.set_tag(tag[2..-1])
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

    def statement_under_max_length?
      return unless statement

      clone_statement = statement.dup
      URI.extract(clone_statement).uniq.each { |url| clone_statement.gsub!(url, '') }
      if clone_statement.length > 200
        errors.add(:statement, " except URLs must be 200 characters or less")
      end
    end
end
