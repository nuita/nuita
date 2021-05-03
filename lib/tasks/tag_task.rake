namespace :tag_task do
  desc 'initialize tags'
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
      puts ''
    end
  end

  # いい感じに自動設定できるようになるまでの仮の姿
  desc 'set featured tags'
  task set_featured_tags: :environment do
    Tag.transaction do
      path = File.expand_path('lib/tasks/tags/tags.yml', Rails.root)
      data = File.open(path) { |f| YAML.safe_load(f) }

      Tag.update_all(featured: false)

      data['featured'].each do |name|
        t = Tag.where(name: name)
        t&.update(featured: true)

        puts "set #{name} as featured"
      end
    end
  end

  desc 'remove unnecessary(not censored by default) tags'
  task clean: :environment do
    Tag.where(censored_by_default: false).destroy_all
  end
end
