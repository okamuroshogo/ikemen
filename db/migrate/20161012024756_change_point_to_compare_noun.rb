class CreateCompareUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :compare_users do |t|
      t.string :twitter_id,   null: false
      t.datetime :last_tweet
      t.integer :weight,    null: false

      t.timestamps
    end
  end
end
