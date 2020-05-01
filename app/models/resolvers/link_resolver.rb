class LinkResolver
  def initialize(url, page)
    @url = url
    @page = page
  end

  def fetch
    attributes = Hash.new
    begin
      attributes[:title] = parse_title
      attributes[:description] = parse_description
      attributes[:image] = parse_image

      if attributes[:image]
        attributes[:image_width], attributes[:image_height] = set_imagesizes(attributes[:image])
      end
    rescue
      attributes[:title] = @url unless attributes[:title]
    end

    attributes
  end

  class << self
    # LinkResolverではヘッダーのcanonicalURL取得するだけ
    # 子クラスで個別にオーバーライドしてクッションページを取り除く必要あり
    def fetch_canonical_url(url)
      page = Nokogiri::HTML.parse(open(url).read)

      if (canonical_url = page.css('//link[rel="canonical"]/@href')).any?
        canonical_url.to_s
      else
        url
      end
    end
  end

  private

    def parse_title
      if @page.css('//meta[property="og:title"]/@content').empty?
        @page.title.to_s.truncate(50)
      else
        @page.css('//meta[property="og:title"]/@content').to_s.truncate(50)
      end
    end

    def parse_description
      if @page.css('//meta[property="og:description"]/@content').empty?
        @page.css('//meta[name$="description"]/@content').to_s.truncate(90)
      else
        @page.css('//meta[property="og:description"]/@content').to_s.truncate(90)
      end
    end

    def parse_image
      @page.css('//meta[property="og:image"]/@content').first.to_s
    end

    def set_imagesizes(image)
      begin
        FastImage.size(image)
      rescue
        logger.debug('failed to set image sizes in #{link.url}')
      end
    end
end
