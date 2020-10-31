class UnsetLimitOfStatementOnNweet < ActiveRecord::Migration[5.2]
  def up
    change_column :nweets, :statement, :text
  end

  def down
    # DBに256文字以上のデータがある場合、rollbackできないので明示的に禁じる
    raise ActiveRecord::IrreversibleMigration
  end
end
