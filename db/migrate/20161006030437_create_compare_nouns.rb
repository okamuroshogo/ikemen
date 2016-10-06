class CreateCompareNouns < ActiveRecord::Migration[5.0]
  def change
    create_table :compare_nouns do |t|
      t.string :noun,	null: false
      t.integer :point, null: false

      t.timestamps
    end
	add_index :compare_nouns, :noun
  end
end
