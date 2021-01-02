namespace :announce_task do
  desc 'Create announcement file. Argument is title'
  task :generate, ['title'] => :environment do |task, args|
    dir = File.expand_path('lib/tasks/announces/', Rails.root)
    time = Time.now.utc.strftime('%Y%m%d%H%M%S')
    title = args[:title].downcase.gsub(/\s/, '_')

    path = "#{dir}/#{time}_#{title}.html"

    File.open(path, 'w') do |f|
      f.puts('<p>Input <strong>the statement</strong> here.</p>')
    end

    p "File created at: #{path}"
  end

  desc 'Announce anything in a HTML file. Argument is filename'
  task :publish, ['filename'] => :environment do |task, args|
    dir = File.expand_path('lib/tasks/announces/', Rails.root)

    path = "#{dir}/#{args[:filename]}"
    statement = ''

    File.open(path, 'r') do |f|
      statement = f.read
    end

    p statement

    User.find_each do |user|
      user.announce(statement)
    end

    p 'Announce success!'
  end

  desc 'Delete all the announces'
  task delete_all: :environment do
    Notification.where(action: :announce).delete_all
    p 'Delete success!'
  end
end
