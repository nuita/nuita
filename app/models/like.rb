class Like < ApplicationRecord
  belongs_to :nweet
  belongs_to :user
  has_one :notification, dependent: :destroy

  validates :nweet_id, uniqueness: {scope: :user_id}

  after_create do
    unless nweet.user == user
      create_notification(origin_id: user.id, destination_id: nweet.user.id, action: :like)
    end
    nweet.update(latest_liked_time: Time.zone.now)
  end
end
