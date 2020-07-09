namespace :link_task do
  desc "refetch all melonbook items"
  task refetch_melonbooks: :environment do
    Link.where("url LIKE '%melonbooks%'").find_each do |link|
      begin
        link.refetch
        print "#{link.id} "
      rescue => e
        puts "\n#{e}"
        p link
      ensure
      end
    end
  end

  desc "refetch all pixiv items"
  task refetch_pixiv: :environment do
    Link.where("url LIKE '%pixiv%'").find_each do |link|
      begin
        link.refetch
        print "#{link.id} "
      rescue => e
        puts "\n#{e}"
        p link
      ensure
      end
    end
  end

  desc "refetch all dlsite items"
  task refetch_dlsite: :environment do
    Link.where("url LIKE '%dlsite%'").find_each do |link|
      begin
        link.refetch
        print "#{link.id} "
      rescue => e
        puts "\n#{e}"
        p link
      ensure
      end
    end
  end

  desc "refetch all links. Use when there the URL columns are same"
  task refetch_all: :environment do
    Link.all.find_each do |link|
      begin
        link.refetch
        print "#{link.id} "
      rescue => e
        puts "\n#{e}"
        p link
      ensure
      end
    end
  end

  desc "[temporary] change tag names and censorings"
  task change_censoring: :environment do
    Tag.find_by(name: 'R-18G')&.destroy
    Tag.find_by(name: 'R18G')&.update_attribute(:name, 'R-18G')
    
    Tag.find_by(name: '3次元')&.destroy
    Tag.find_by(name: '3D')&.update_attribute(:name, '3次元')

    User.find_each do |user|
      user.censor 'スカトロ'
    end
  end
end
