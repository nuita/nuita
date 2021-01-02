class Tag < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}, uniqueness: {case_sensitive: false}

  has_many :link_tags, dependent: :destroy
  has_many :links, through: :link_tags

  has_many :preferences, dependent: :destroy

  before_save :set_censored_by_default
  before_validation { name.upcase! }

  CENSORED_TAG_NAMES = ['R-18G', 'スカトロ'].freeze

  private

    def set_censored_by_default
      if CENSORED_TAG_NAMES.include?(name)
        self.censored_by_default = true
      end
    end
end
