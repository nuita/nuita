class AddContextToPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :preferences, :context, :integer, default: 0, null: false

    add_index :preferences, [:user_id, :tag_id], unique: true
  end
end
