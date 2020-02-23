class Portfolio < ApplicationRecord
  belongs_to :artist
  has_many :images, through: :has_image
  has_many :tags, through: :has_tag
end
