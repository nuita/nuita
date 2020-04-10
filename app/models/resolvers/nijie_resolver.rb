class NijieResolver < LinkResolver
  class << self
    def fetch_canonical_url(url)
      url.sub!(/sp.nijie/, 'nijie')
      url.sub(/view_popup/, 'view')
    end
  end

  private

    def parse_image
      str = @page.css('//script[@type="application/ld+json"]/text()').first.to_s

      if s = str.match(/https:\/\/pic.nijie.(net|info)\/(?<servername>\d+)\/[^\/]+\/nijie_picture\/(?<imagename>[^"]+)/)
        # 動画は容量大きすぎるし取らない
        if s[:imagename] =~ (/(jpg|png)/)
          'https://pic.nijie.net/' + s[:servername] + '/nijie_picture/' + s[:imagename]
        else
          s[0]
        end
      else
        @page.css('//meta[property="og:image"]/@content').first.to_s
      end
    end
end
