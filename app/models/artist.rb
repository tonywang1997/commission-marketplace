class Artist < ApplicationRecord
  has_many :images, through: :has_image
  has_many :portfolios
  belongs_to :user
end
