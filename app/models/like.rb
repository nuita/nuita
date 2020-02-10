class Like < ApplicationRecord
  belongs_to :nweet
  belongs_to :user
  has_one :notification, dependent: :destroy

  validates_uniqueness_of :nweet_id, scope: :user_id

  after_create do
    unless nweet.user == user
      create_notification(origin_id: user.id, destination_id: nweet.user.id, action: :like)
    end
    nweet.update_attributes(latest_liked_time: Time.zone.now)
  end
end
