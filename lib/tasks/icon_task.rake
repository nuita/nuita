namespace :icon_task do
  desc "resize all usericons"
  task resize_all: :environment do
    User.find_each do |user|
      begin
        if user.icon.present?
          print "#{user.id} "
          user.icon.cache_stored_file!
          user.icon.retrieve_from_cache!(user.icon.cache_name)
          user.icon.recreate_versions!
          user.save!
        end
      rescue => e
        puts "ERROR: User: #{user.id} -> #{e.to_s}"
      end
    end
    puts 'recreation done.'
  end
end
