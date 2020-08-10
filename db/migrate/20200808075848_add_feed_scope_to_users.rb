class AddFeedScopeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :feed_scope, :integer, default: 0, null: false
  end
end
