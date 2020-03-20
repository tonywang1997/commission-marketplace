class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :has_tags
  has_many :images, through: :has_images
  has_many :tags, through: :has_tags
  has_many_attached :files
end
