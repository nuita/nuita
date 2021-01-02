# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(handle_name: 'ちくわ大明神', screen_name: 'chikuwa', email: 'chikuwa@daimyojin.com', password: 'chikuwa00', biography: '誰だ今の')

Faker::Config.locale = :en
49.times do |n|
  handle_name = Faker::Name.unique.name
  screen_name = User.screen_name_formatter(handle_name)
  email = Faker::Internet.email
  password = Faker::Internet.password
  User.create!(handle_name: handle_name, screen_name: screen_name, email: email, password: password)
end

User.all.map do |user|
  5.times do
    user.nweets.create(did_at: Faker::Time.backward(days: 50), statement: Faker::Lorem.sentence)
    user.nweets.create(did_at: Faker::Time.backward(days: 50))
  end
end

users = User.all
first_user = users.first
nweet = first_user.nweets.create(did_at: Time.zone.now, statement: 'https://www.pixiv.net/artworks/55434358')

followees = users[2..50]
followers = users[3..40]
followees.each { |followee| first_user.follow(followee) }
followers.each { |follower| follower.follow(first_user) }

confident_users = users[9..30]
confident_users.each do |user|
  user.update_attribute(:biography, Faker::Lorem.sentence.truncate(29))
  user.liked_nweets << nweet
  first_user.liked_nweets << user.nweets.first
end

Rake::Task['tag_task:init'].execute
