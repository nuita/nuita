class AddFeaturedToNweets < ActiveRecord::Migration[6.0]
  def change
    add_column :nweets, :featured, :boolean, default: false, null: false
  end
end
