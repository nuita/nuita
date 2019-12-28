namespace :link_task do
  desc "refetch all melonbook items"
  task refetch_melonbooks: :environment do
    Link.where("url LIKE '%melonbooks%'").find_each do |link|
      link.refetch
      p link
    end
  end

  task refetch_pixiv: :environment do
    Link.where("url LIKE '%pixiv%'").find_each do |link|
      link.refetch
      p link
    end
  end
end