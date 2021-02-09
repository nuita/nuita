namespace :nweet_task do
  desc 'Set random url-digest to existing nweets'
  task set_url_digest: :environment do
    Nweet.all.each do |nweet|
      if nweet.url_digest.nil?
        nweet.url_digest = SecureRandom.alphanumeric
        nweet.save
      end
    end
  end

  desc 'Refresh (and create) links on existing nweets. Use when there are changes in URL columns'
  task refresh_link: :environment do
    Nweet.all.find_each do |nweet|
      nweet.create_link
    rescue StandardError => e
      puts e
    ensure
      p nweet.links.first
    end
  end

  desc 'Destroy all links'
  task destroy_link: :environment do
    Link.destroy_all
  end

  desc 'set first featurable nweets'
  task set_featured_nweets: :environment do
    # ヌイート先にいいねがある最近のリンクを抽出
    links = Link.joins(nweets: :likes).distinct.limit(100)
    links.find_each do |link|
      begin
        link.refetch
      rescue StandardError => e
        puts e
        next
      end

      puts link.url, link.resolver

      # 本来はいいねつきの投稿が複数回されたなら複数表示されるべきですが、
      # 今回は初期値を取るだけなので初回だけを取るように簡略化
      link.nweets.first.update(featured: true) if link.featurable?
    end
  end
end
