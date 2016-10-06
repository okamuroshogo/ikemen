class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :twitter_id
      t.string :image_url
      t.integer :point
      t.string :detail

      t.timestamps
    end
  end
end
