require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/rake'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/scm/git'

install_plugin Capistrano::SCM::Git

# taskを記述したファイルを読み込む用に設定。
# なおデフォルトでは *.rakeとなっているのでもとの記述をそのまま使う場合は注意!！
Dir.glob('lib/capistrano/tasks/*.rb').each { |r| import r }
