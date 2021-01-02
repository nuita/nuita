class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :origin_id
      t.integer :destination_id, index: true

      t.integer :action, null: false

      t.integer :like_id
      t.integer :relationship_id

      t.boolean :checked, null: false, default: false

      t.timestamps
    end
  end
end
