class Tag < ApplicationRecord
  before_save { 
    self.tag_name.downcase!
  }
  
  has_many :has_tags
  has_many :portfolios, through: :has_tags
  validates :tag_name, presence: true
end
