class ChangeLastTweetToCompareUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :compare_users, :last_tweet, :string
  end
end
