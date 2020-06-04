namespace :tag_task do
  desc "initialize tags"
  task init: :environment do
    Preference.destroy_all
    Tag.destroy_all

    Tag.create(name: 'R18G', description: '猟奇的・残酷な描写')
    Tag.create(name: '3D', description: '撮影された動画や画像')

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
