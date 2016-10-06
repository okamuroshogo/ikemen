class User < ApplicationRecord
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth['uid']
      user.twitter_id = auth['info']['nickname']
    end
  end
end
