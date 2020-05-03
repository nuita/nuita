class PixivResolver < LinkResolver
  def initialize(url, page)
    super(url, page)
    @illust_id = url.slice(/pixiv\.net\/(member_illust.php?.*illust_id=|artworks\/)(\d+)/, 2)

    json_uri = URI.parse("https://www.pixiv.net/ajax/illust/#{@illust_id}")
    @json = JSON.parse(Net::HTTP.get(json_uri))
  end

  class << self
    def fetch_canonical_url(url)
      illust_id = url.slice(/pixiv\.net\/(member_illust.php?.*illust_id=|artworks\/)(\d+)/, 2)
      'https://pixiv.net/member_illust.php?mode=medium&illust_id=' + illust_id
    end
  end

  private

    def parse_image
      begin
        proxy_url = "https://pixiv.cat/#{@illust_id}.jpg"
        # ↑で404だったら複数絵かも
        case Net::HTTP.get_response(URI.parse(proxy_url))
        when Net::HTTPNotFound
          proxy_url = "https://pixiv.cat/#{@illust_id}-1.jpg"
        end

        proxy_url
      rescue
        @page.css('//meta[property="og:image"]/@content').first.to_s
      end
    end

    def parse_tags
      @tags = @json['body']['tags']['tags'].map{|content| content['tag']}
    end
end
