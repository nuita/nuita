class RenameCategoriesToTags < ActiveRecord::Migration[5.2]
  def change
    rename_table :categories, :tags
    rename_table :link_categories, :link_tags
  end
end
