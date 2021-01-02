namespace :twitter_task do
  desc "Disable autotweet when no account is registered"
  task disable_autotweet_with_no_account: :environment do
    User.where(twitter_uid: nil).update_all(autotweet_enabled: false)
  end
end
