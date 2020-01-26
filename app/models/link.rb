require 'json'
require 'net/http'

class Link < ApplicationRecord
  before_create :fetch_infos

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
    def normalize_url(url)
      case url
      when /nijie/
        url.sub!(/sp.nijie/, 'nijie')
        url.sub(/view_popup/, 'view')
      when /melonbooks.co.jp\/detail\/detail.php\?product_id=(\d+)/
        'https://www.melonbooks.co.jp/detail/detail.php?product_id=' + $1 + '&adult_view=1'
      when /komiflo\.com(?:\/#!)?\/comics\/(\d+)/
        'https://komiflo.com/comics/' + $1
      when /pixiv\.net\/(member_illust.php?.*illust_id=|artworks\/)(\d+)/
        'https://pixiv.net/member_illust.php?mode=medium&illust_id=' + $2
      else
        url
      end
    end

    def recommend
      Link.offset(rand(Link.count)).first
    end
  end

  private

    def fetch_infos
      case self.url
      when /komiflo\.com(?:\/#!)?\/comics\/(\d+)/
        resolve_komiflo($1)
      else
        begin
          page = Nokogiri::HTML.parse(open(self.url).read)
          # これは本当に最悪　全部サイトごとの関数にリファクタリングする
          self.title = parse_title(page)
          self.description = parse_description(page)
          self.image = parse_image(page)
          set_imagesizes
        rescue
          self.title = self.url
        end
      end
    end

    def parse_title(page)
      if page.css('//meta[property="og:title"]/@content').empty?
        page.title.to_s.truncate(50)
      else
        page.css('//meta[property="og:title"]/@content').to_s.truncate(50)
      end
    end

    def parse_description(page)
      case self.url
      when /melonbooks/
        # スタッフの紹介文でidが分岐
        special_description = page.xpath('//div[@id="special_description"]//p/text()')
        if special_description.any?
          special_description.first.to_s.truncate(90)
        else
          description = page.xpath('//div[@id="description"]//p/text()')
          description.first.to_s.truncate(90)
        end
      else
        if page.css('//meta[property="og:description"]/@content').empty?
          page.css('//meta[name$="description"]/@content').to_s.truncate(90)
        else
          page.css('//meta[property="og:description"]/@content').to_s.truncate(90)
        end
      end
    end

    def parse_image(page)
      case self.url
      when /dlsite/
        page.css('//meta[property="og:image"]/@content').first.to_s.sub(/sam/, 'main')
      when /nijie/
        str = page.css('//script[@type="application/ld+json"]/text()').first.to_s

        if s = str.match(/https:\/\/pic.nijie.(net|info)\/(?<servername>\d+)\/[^\/]+\/nijie_picture\/(?<imagename>[^"]+)/)
          # 動画は容量大きすぎるし取らない
          if s[:imagename] =~ (/(jpg|png)/)
            'https://pic.nijie.net/' + s[:servername] + '/nijie_picture/' + s[:imagename]
          else
            s[0]
          end
        else
          page.css('//meta[property="og:image"]/@content').first.to_s
        end
      when /pixiv.*[^fanbox](illust_id=|artworks\/)(\d+)/
        proxy_url = "https://pixiv.cat/#{$2}.jpg"
        # ↑で404だったら複数絵かも
        case Net::HTTP.get_response(URI.parse(proxy_url))
        when Net::HTTPNotFound
          proxy_url = "https://pixiv.cat/#{$2}-1.jpg"
        end

        proxy_url
      when /melonbooks/
        str = page.css('//meta[property="og:image"]/@content').first.to_s.sub(/&c=1/, '')
      else
        page.css('//meta[property="og:image"]/@content').first.to_s
      end
    end

    # 項目ごとに分岐するのは失敗だった気がする。最初にサイトごとに分岐してしまったほうが楽
    # 特にkomifloの場合は全項目jsonから判断しなきゃいけないので……
    def resolve_komiflo(id)
      begin
        uri = URI.parse("https://api.komiflo.com/content/id/#{id}")
        json = JSON.parse(Net::HTTP.get(uri))

        author = json['content']['attributes']['artists']['children'][0]['data']['name']

        comic_title = json['content']['data']['title']
        self.title = "#{comic_title} | Komiflo"

        parent = json['content']['parents'][0]['data']['title']
        self.description = '著: ' + author if author
        self.description += " / #{parent}" if parent

        self.image = 'https://t.komiflo.com/564_mobile_large_3x/' + json['content']['named_imgs']['cover']['filename'];
      rescue
        self.title = self.url
      end
    end

    def set_imagesizes
      begin
        self.image_width, self.image_height = FastImage.size(self.image)
      rescue
        logger.debug('failed to set image sizes in #{link.url}')
      end
    end
end
