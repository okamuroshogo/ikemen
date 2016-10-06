class CreateCompareNouns < ActiveRecord::Migration[5.0]
  def change
    create_table :compare_nouns do |t|
      t.string :noun
      t.integer :point

      t.timestamps
    end
  end
end
