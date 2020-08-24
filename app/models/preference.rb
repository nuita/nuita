class Preference < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :user, presence: true, uniqueness: {scope: :tag, message: ' and tag must be unique'}
  validates :tag, presence: true
  validates :context, presence: true

  enum context: [:censoring, :preferring]
end
