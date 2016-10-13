class ChangePointToCompareNoun < ActiveRecord::Migration[5.0]
# 変更内容
  def up
    change_column :compare_nouns, :point, :integer, null: false, default: 0
  end

  # 変更前の状態
  def down
    change_column :compare_nouns, :point, :integer
  end
end
