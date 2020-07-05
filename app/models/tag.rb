class Tag < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}, :uniqueness => {case_sensitive: false}

  has_many :link_tags, dependent: :destroy
  has_many :links, through: :link_tags

  has_many :preferences, dependent: :destroy

  before_save :set_censored_by_default
  before_validation { name.upcase! }

  private

    def set_censored_by_default
      # こんなのハードコーディングすべきじゃない気がする
      censor_list = ['3D', 'R-18G', 'スカトロ']

      if censor_list.include?(name)
        self.censored_by_default = true
      end
    end
end
