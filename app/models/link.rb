class Link < ApplicationRecord
  has_many :nweet_links, dependent: :destroy
  has_many :nweets, through: :nweet_links

  has_many :link_tags, dependent: :destroy
  has_many :tags, through: :link_tags

  validates :title, length: {maximum: 100}
  validates :description, length: {maximum: 500}
  validates :author, length: {maximum: 50}
  validates :circle, length: {maximum: 50}

  validates :url, url: true

  scope :displayable, -> { where.not(image: [nil, '']).left_outer_joins(:tags).where(tags: {censored_by_default: nil}) }

  # Resolvers where nweets might contain illegal contents.
  UNSAFE_RESOLVERS = ['', 'Image'].freeze

  # Should be used only in link_task:refetch_all
  def refetch
    panchira = Panchira.fetch(url)
    canonical_url = panchira.canonical_url

    # 現在のURLが取得したcanonical_urlとは異なるのに、レコードにその記録がある場合は、
    # 保存するとURL重複となるためスルーする
    return if url != canonical_url && Link.find_by(url: canonical_url)

    update(self.class.hash_panchira(panchira))
    set_tags(panchira.tags, destroy_existing_tags: false)
    save
  end

  def set_tag(name)
    unless tags.exists?(name: name.upcase)
      tags << Tag.find_or_create_by(name: name.upcase)
    end
  end

  def remove_tag(name)
    name.upcase!
    tags.delete(Tag.find_by(name: name))
  end

  def set_tags(names, destroy_existing_tags: true)
    remove_tags if destroy_existing_tags

    names.each { |name| set_tag(name) }
  end

  def remove_tags
    link_tags.destroy_all
  end

  def legal?
    return false unless resolver

    r = resolver.match(/Panchira::([a-zA-Z]*)Resolver/).to_a[1]
    UNSAFE_RESOLVERS.exclude?(r)
  end

  def featurable?
    legal? && image.present? && !tags.exists?(censored_by_default: true)
  end

  class << self
    # URLを正規化してfind_or_initialize_by + fetchしてくる
    def fetch_from(url)
      panchira = Panchira.fetch(url)
      canonical_url = panchira.canonical_url
      link = Link.find_or_initialize_by(url: canonical_url)

      link.update(hash_panchira(panchira))
      link.set_tags(panchira.tags, destroy_existing_tags: false) if panchira.tags

      link
    end

    # Convert PanchiraResult to Link attributes
    def hash_panchira(panchira)
      {
        title: panchira.title&.truncate(100),
        author: panchira.author&.truncate(50),
        circle: panchira.circle&.truncate(50),
        description: panchira.description&.truncate(500),
        image: panchira.image.url,
        image_width: panchira.image.width,
        image_height: panchira.image.height,
        url: panchira.canonical_url,
        resolver: panchira.resolver || 'Panchira::Resolver'
      }
    end
  end
end
