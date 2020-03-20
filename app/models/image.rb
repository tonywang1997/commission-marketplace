class Image < ApplicationRecord
  has_many :has_images
  has_many :portfolios, through: :has_images
end
