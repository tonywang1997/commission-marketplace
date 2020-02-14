class Portfolio < ApplicationRecord
  belongs_to :artist
  has_many :images, through: :has_image
end
