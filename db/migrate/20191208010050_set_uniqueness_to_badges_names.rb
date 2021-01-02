class SetUniquenessToBadgesNames < ActiveRecord::Migration[5.2]
  def change
    add_index :badges, :name, unique: true
  end
end
