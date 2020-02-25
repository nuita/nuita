require 'json'
require 'net/http'

class Link < ApplicationRecord
  has_many :nweet_links, dependent: :destroy
  has_many :nweets, through: :nweet_links

  has_many :link_categories, dependent: :destroy
  has_many :categories, through: :link_categories

  validates :title, length: {maximum: 100}
  validates :description, length: {maximum: 500}

  validates :url, :url => true

  def refetch
    fetch_infos
    save
  end

  def set_category(name)
    if c = Category.find_by(name: name.upcase)
      self.categories << c
    end
  end

  def remove_category(name)
    name.upcase!
    categories.delete(Category.find_by(name: name))
  end

  class << self
    def recommend
      Link.offset(rand(Link.count)).first
    end

    # Create or find a record from (potentially not canonical) URL.
    # Use this instead of standard Link.create or Link.find_by(url: ...)
    def fetch_from(url, refetch_existing_url: true)
      page = Nokogiri::HTML.parse(open(url).read)
      resolver = select_resolver(url)

      canonical_url = resolver.fetch_cannonical_url(url)
      link = Link.find_or_initialize_by(url: canonical_url)
      link.update_attributes(resolver.new(canonical_url).fetch(page))

      link
    end

    def select_resolver(url)
      LinkResolver
    end
  end
end
