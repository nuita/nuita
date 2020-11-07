class AddAuthorAndCircleToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :author, :string, limit: 50
    add_column :links, :circle, :string, limit: 50
  end
end
