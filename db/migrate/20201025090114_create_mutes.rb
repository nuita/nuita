class CreateMutes < ActiveRecord::Migration[5.2]
  def change
    create_table :mutes do |t|
      t.integer :muter_id
      t.integer :mutee_id

      t.timestamps
    end

    add_index :mutes, :muter_id
    add_index :mutes, :mutee_id
    add_index :mutes, [:muter_id, :mutee_id], unique: true
  end
end
