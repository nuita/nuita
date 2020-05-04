class Preference < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :user, presence: true
  validates :tag, presence: true

  # User can have multiple Prefences which express different meanings. (e.g. mute list and block list)
  # Therefore, a pair of user and tag doesn't have to be unique.
  # validates_uniqueness_of :user_id, scope: :tag_id
end
