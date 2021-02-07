class AddResolverToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :resolver, :string
  end
end
