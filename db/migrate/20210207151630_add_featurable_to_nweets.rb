class AddFeaturableToNweets < ActiveRecord::Migration[6.0]
  def change
    add_column :nweets, :featurable, :boolean, default: false, null: false
  end
end
