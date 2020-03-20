class Portfolio < ApplicationRecord
  belongs_to :artist, optional: true
  has_many :images, through: :has_image
  has_many_attached :files
end
