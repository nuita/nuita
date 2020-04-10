class KomifloResolver < LinkResolver
  def initialize(url, page)
    super(url, page)

    @id = url.slice(/komiflo\.com(?:\/#!)?\/comics\/(\d+)/, 1)

    json_uri = URI.parse("https://api.komiflo.com/content/id/#{@id}")
    @json = JSON.parse(Net::HTTP.get(json_uri))
  end

  # KomifloはJSON経由でfetchするか
  def parse_title
    comic_title = @json['content']['data']['title']
    "#{comic_title} | Komiflo"
  end

  def parse_image
    @image = 'https://t.komiflo.com/564_mobile_large_3x/' + @json['content']['named_imgs']['cover']['filename']
  end

  def parse_description
    author = @json['content']['attributes']['artists']['children'][0]['data']['name']

    parent = @json['content']['parents'][0]['data']['title']
    @description = '著: ' + author if author
    @description += " / #{parent}" if parent
  end

  class << self
    def fetch_canonical_url(url)
      id = url.slice(/komiflo\.com(?:\/#!)?\/comics\/(\d+)/, 1)
      'https://komiflo.com/comics/' + id
    end
  end
end
