class SetDefaultsInPrivacyInNweets < ActiveRecord::Migration[5.2]
  def up
    change_column_null :nweets, :privacy, false, 0
    change_column :nweets, :privacy, :integer, default: 0
  end

  def down
    change_column_null :nweets, :privacy, true, nil
    change_column :nweets, :privacy, :integer, default: nil
  end
end
