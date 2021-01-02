class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  enum action: [:like, :follow, :announce]

  belongs_to :like, optional: true
  belongs_to :origin, class_name: 'User', optional: true
  belongs_to :destination, class_name: 'User'

  validates :statement, length: {maximum: 255}
end
