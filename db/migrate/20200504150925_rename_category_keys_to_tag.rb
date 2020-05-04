class RenameCategoryKeysToTag < ActiveRecord::Migration[5.2]
  def change
    rename_column :link_tags, :category_id, :tag_id
    rename_column :preferences, :category_id, :tag_id
  end
end
