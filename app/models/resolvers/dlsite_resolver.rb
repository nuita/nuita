class DlsiteResolver < LinkResolver
  private

    def parse_image
      @page.css('//meta[property="og:image"]/@content').first.to_s.sub(/sam/, 'main')
    end

    def parse_tags
      @page.css('.main_genre').children.children.map(&:text)
    end
end
