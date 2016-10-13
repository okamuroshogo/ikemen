class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :uid,    null: false
      t.string :twitter_id, null: false
      t.string :image_url
      t.integer :point
      t.string :detail
      t.timestamps 
    end
  add_index :users, :uid, unique: true
  end
end
