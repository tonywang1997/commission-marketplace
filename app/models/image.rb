class Image < ApplicationRecord
  has_many :has_images
  has_many :portfolios, through: :has_images

  scope :tagged, -> (tags) { joins(:portfolios).where('portfolios.id IN (?)', Portfolio.tagged(tags).pluck(:id)).distinct }
end
