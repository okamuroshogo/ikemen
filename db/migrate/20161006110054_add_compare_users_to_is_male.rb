class AddCompareUsersToIsMale < ActiveRecord::Migration[5.0]
  def change
    add_column :compare_users, :is_male, :Boolean, default: false, null: false, after: :twitter_id
  end
end
