class AddCompareNounsToIsMale < ActiveRecord::Migration[5.0]
  def change
    add_column :compare_nouns, :is_male, :Boolean, default: false, null: false, after: :point
  end
end
