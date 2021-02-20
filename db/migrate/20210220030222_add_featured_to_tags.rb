class AddFeaturedToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :featured, :boolean, default: false, null: false
  end
end
