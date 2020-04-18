class Image < ApplicationRecord
  has_many :has_images
  has_many :portfolios, through: :has_images
  has_one_attached :file

  def self.tagged(tags)
    if tags.empty?
      return all
    end
    joins(:portfolios).where('portfolios.id IN (?)', Portfolio.tagged(tags).distinct.pluck(:id))
  end

  def tags
    Tag.joins(:portfolios => :images).
        where('images.id = ?', self.id).
        distinct.
        order(:tag_name => 'asc').
        pluck(:tag_name)
  end
end
