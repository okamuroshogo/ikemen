class AddIndexToCompareNouns < ActiveRecord::Migration[5.0]
  def up
    remove_index :compare_nouns, :noun
    add_index :compare_nouns, [:noun, :is_male], unique: true
  end

  def down
    remove_index :compare_nouns, [:noun, :is_male] 
    add_index :compare_nouns, :noun 
  end
end
