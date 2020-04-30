require "uri"
require "nokogiri"
require "open-uri"

module ApplicationHelper
  def text_url_to_link(text)
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target='_blank'>" << url << "</a>"

      text.gsub!(url, sub_text)
    end
    text
  end

  # contribution graph用
  # collectionを渡すとcolumnの日ごとに整理されたhashになって返ってくる
  def calendarize_data(collection, column: :created_at)
    Hash.new([]).tap do |hash|
      collection.each do |c|
        date = c.send(column).in_time_zone('Tokyo').to_date
        hash[date] = [] if hash[date].empty?
        hash[date] << c
      end
    end
  end

  # returns camo url only in production mode
  def camo_url(url)
    if Rails.env.production? && /http:\/\// =~ url
      camo(url)
    else
      url
    end
  end
end
