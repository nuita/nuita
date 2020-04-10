class MelonbooksResolver < LinkResolver
  class << self
    def fetch_canonical_url(url)
      product_id = url.slice(/melonbooks.co.jp\/detail\/detail.php\?product_id=(\d+)/, 1)
      'https://www.melonbooks.co.jp/detail/detail.php?product_id=' + product_id + '&adult_view=1'
    end
  end

  private

    def parse_description
      # スタッフの紹介文でidが分岐
      special_description = @page.xpath('//div[@id="special_description"]//p/text()')
      if special_description.any?
        special_description.first.to_s.truncate(90)
      else
        description = @page.xpath('//div[@id="description"]//p/text()')
        description.first.to_s.truncate(90)
      end
    end

    def parse_image
      @page.css('//meta[property="og:image"]/@content').first.to_s.sub(/&c=1/, '')
    end
end
