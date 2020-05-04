class LinkTag < ApplicationRecord
  belongs_to :link
  belongs_to :tag

  validates :link_id, presence: :true
  validates :tag_id, presence: :true
end
