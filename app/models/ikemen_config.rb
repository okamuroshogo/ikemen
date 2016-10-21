class IkemenConfig < ApplicationRecord
    serialize :value
    scope :point_sum,     -> { find_by(key: 'point_sum') }
    scope :cnt,           -> { find_by(key: 'user_count') }

end
