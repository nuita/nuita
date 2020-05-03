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
end
