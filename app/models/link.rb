class Link < ApplicationRecord
  has_many :nweet_links, dependent: :destroy
  has_many :nweets, through: :nweet_links

  has_many :link_tags, dependent: :destroy
  has_many :tags, through: :link_tags

  validates :title, length: {maximum: 100}
  validates :description, length: {maximum: 500}

  validates :url, :url => true

  scope :displayable, -> { where.not(image: [nil, '']).left_outer_joins(:tags).where(tags: {censored_by_default: nil}) }

  # Should be used only in link_task:refetch_all
  def refetch
    resolver = Link.select_resolver(url)
    canonical_url = resolver.fetch_canonical_url(url)

    # 現在のURLが取得したcanonical_urlとは異なるのに、レコードにその記録がある場合は、
    # 保存するとURL重複となるためスルーする
    return if url != canonical_url && Link.find_by(url: canonical_url)

    page = Nokogiri::HTML.parse(open(canonical_url).read)
    update_attributes(resolver.new(canonical_url, page).fetch)
    save
  end

  def set_tag(name)
    if t = Tag.find_or_create_by(name: name.upcase)
      self.tags << t
    end
  end

  def remove_tag(name)
    name.upcase!
    tags.delete(Tag.find_by(name: name))
  end

  def set_tags(names, destroy_existing_tags: true)
    remove_tags if destroy_existing_tags
    
    names.each{|name| set_tag(name)}
  end

  def remove_tags
    link_tags.destroy_all
  end

  class << self
    def recommend(displayable: false)
      if(displayable)
        link = Link.displayable  
      else
        link = Link.all
      end
      
      link.offset(rand(link.count)).first
    end

    # URLを正規化してfind_or_initialize_by + fetchしてくる
    def fetch_from(url)
      resolver = select_resolver(url)

      canonical_url = resolver.fetch_canonical_url(url)
      page = Nokogiri::HTML.parse(open(canonical_url).read)

      link = Link.find_or_initialize_by(url: canonical_url)
      link.update_attributes(resolver.new(canonical_url, page).fetch)

      link
    end

    def select_resolver(url)
      case(url)
      when /komiflo\.com(?:\/#!)?\/comics\/(\d+)/
        KomifloResolver
      when /melonbooks.co.jp\/detail\/detail.php\?product_id=(\d+)/
        MelonbooksResolver
      when /pixiv\.net\/(member_illust.php?.*illust_id=|artworks\/)(\d+)/
        PixivResolver
      when /nijie.*view.*id=\d+/
        NijieResolver
      when /dlsite/
        DlsiteResolver
      else
        LinkResolver
      end
    end
  end
end
