class ChangeNweetStatementLength < ActiveRecord::Migration[6.0]
  def up
    change_column :nweets, :statement, :string, limit: 200
  end

  def down
    # DBに100文字より長いデータがある場合は失敗する
    change_column :nweets, :statement, :string, limit: 100
  end
end
