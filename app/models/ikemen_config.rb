class IkemenConfig < ApplicationRecord
    serialize :value
    KEY_POINT_SUM = 'point_sum'
    KEY_USER_COUNT = 'user_count'

  def self.cnt
    find_by(key: KEY_USER_COUNT)
  end

  def self.point_sum
    find_by(key: KEY_POINT_SUM)
  end
end
