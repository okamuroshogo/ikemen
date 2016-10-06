class CreateCompareUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :compare_users do |t|
      t.string :twitter_id
      t.datetime :last_tweet
      t.integer :weight

      t.timestamps
    end
  end
end
