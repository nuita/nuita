class AddImageSizesToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :image_width, :integer
    add_column :links, :image_height, :integer
  end
end
