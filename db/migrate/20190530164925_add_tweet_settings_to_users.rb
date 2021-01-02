class AddTweetSettingsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :autotweet_enabled, :boolean, default: false
    add_column :users, :autotweet_content, :string, limit: 40, default: '射精しました！ #nuita [LINK]'
  end
end
