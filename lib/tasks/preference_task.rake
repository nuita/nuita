namespace :preference_task do
  desc 'delete duplicate preference'
  task clean_duplicates: :environment do
    hash = Preference.group(:user_id, :tag_id).having('count(*) >= 2').maximum(:id)

    Preference.where(id: hash.values).destroy_all
  end
end
