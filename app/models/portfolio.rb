class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :has_tags
  has_many :images, through: :has_images
  has_many :tags, through: :has_tags

  scope :tagged, -> (tags) { joins(:tags).where("tags.tag_name IN (?)", tags).group("portfolios.id").having('count(*) = ?', tags.count) }
  has_many_attached :files
end
