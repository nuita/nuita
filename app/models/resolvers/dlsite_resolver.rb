class DlsiteResolver < LinkResolver
  private

    def parse_image
      @page.css('//meta[property="og:image"]/@content').first.to_s.sub(/sam/, 'main')
    end
end
