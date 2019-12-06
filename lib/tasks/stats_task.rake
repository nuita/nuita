namespace :stats_task do
  desc "count stats"
  task :count => :environment do
    puts "#{User.count} users"
    puts "#{Nweet.count} nweets"
    puts "#{Link.count} links"
  end
end
