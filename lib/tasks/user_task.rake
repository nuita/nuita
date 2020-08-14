namespace :user_task do
  desc "Set random url-digest to existing users"
  task :set_url_digest => :environment do
    User.all.each do |user|
      if user.url_digest.nil?
        user.url_digest = SecureRandom.alphanumeric
        user.save
      end
    end
  end

  desc "set existing users' feed scope to global"
  task :set_feed_scope_to_global => :environment do
    User.all.find_each do |user|
      user.update_attribute(:feed_scope, :global)
    end
  end
end
