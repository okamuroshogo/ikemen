class CompareNoun < ApplicationRecord
  scope :male, -> { where(is_male: true) }
  scope :female, -> { where(is_male: false) }
end
