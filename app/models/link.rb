class Link < ApplicationRecord
  has_many :nweet_links, dependent: :destroy
  has_many :nweets, through: :nweet_links

  has_many :link_categories, dependent: :destroy
  has_many :categories, through: :link_categories

  validates :title, length: {maximum: 100}
  validates :description, length: {maximum: 500}

  validates :url, :url => true

  scope :displayable, -> { where.not(image: [nil, '']).left_outer_joins(:categories).where(categories: {censored_by_default: nil}) }

  # Should be used only in link_task:refetch_all
  def refetch
    resolver = select_resolver(url)
    canonical_url = resolver.fetch_canonical_url(url)

    # 現在のURLが取得したcanonical_urlとは異なるのに、レコードにその記録がある場合は、
    # 保存するとURL重複となるためスルーする
    return if url != canonical_url && Link.find_by(url: canonical_url)

    page = Nokogiri::HTML.parse(open(canonical_url).read)
    update_attributes(resolver.new(canonical_url, page).fetch)
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
