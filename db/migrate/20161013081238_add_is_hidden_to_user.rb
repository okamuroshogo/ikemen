class AddIsHiddenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_hidden, :Boolean, after: :twitter_id
  end
end
