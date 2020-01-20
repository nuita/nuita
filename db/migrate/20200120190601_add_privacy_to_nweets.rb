class AddPrivacyToNweets < ActiveRecord::Migration[5.2]
  def change
    add_column :nweets, :privacy, :integer
  end
end
