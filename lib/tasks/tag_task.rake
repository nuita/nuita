namespace :tag_task do
  desc "initialize tags"
  task init: :environment do
    Preference.destroy_all
    Tag.destroy_all

    Tag.create(name: 'R-18G')
    Tag.create(name: 'スカトロ')

    Tag.where(censored_by_default: true).each do |tag|
      puts "censoring #{tag.name}..."
      User.find_each do |user|
        print "#{user.id} "
        user.censored_tags << tag
      end
      puts ""
    end
  end

  desc "remove unnecessary(not censored by default) tags"
  task clean: :environment do
    Tag.where(censored_by_default: false).destroy_all
  end
end
