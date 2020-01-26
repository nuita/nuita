require 'uri'

class Nweet < ApplicationRecord
  enum privacy: {to_everyone: 0, to_followers: 1, to_author_only: 3}
  # to_friends: 2 is not used for now

  before_create :set_url_digest

  # statementはeditで編集されるのでafter_createではだめ
  after_save :create_link, :create_category

  # begin christmas
  after_create do
    self.stamps.create(targeted_at: self.did_at, action: :nweet, user: self.user)
  end

  has_many :stamps, dependent: :destroy

  # end christmas

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :nweet_links, dependent: :destroy
  has_many :links, through: :nweet_links

  validates :user_id, presence: true
  validates :did_at, presence: true
  validates :statement, length: {maximum: 100}
  validate :did_at_past?
  validate :have_enough_interval?, on: :create

  default_scope -> { order(did_at: :desc) }
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
        url = Link.normalize_url(url)
        if l = Link.find_by(url: url)
          self.links << l
          l.refetch
        else
          self.links.create(url: url)
        end
      end
    end
  end

  def create_category
    if links.any?
      # 本当は空白に置換したかったけどコールバックの前後関係で無理そう
      self.statement.scan(/\s#\S*/) do |tag|
        links.each do |link|
          link.set_category(tag[2..-1])
        end
      end
    end
  end

  private
    def set_url_digest
      self.url_digest = SecureRandom.alphanumeric
    end
end
