class Image < ApplicationRecord
  has_many :has_images
  has_many :portfolios, through: :has_images
  has_one_attached :file

  def self.tagged(tags)
    if tags.empty?
      return all
    end
    # select(:id).joins(:portfolios => :tags).where("tags.tag_name IN (?)", tags).distinct.group(:id).having('count(*) = ?', tags.count)
    from(Image.joins(:portfolios => :tags).where("tags.tag_name IN (?)", tags).select('"tags"."tag_name"').distinct, :filtered_images).group(:id, :price, :date).having('count(*) = ?', tags.count)
  end

  def self.in_price_range(price_range)
    if price_range.empty?
      return all
    end
    where('price > ? and price < ?', price_range[0], price_range[1])
  end

  def tags
    Tag.joins(:portfolios => :images).
        where('images.id = ?', self.id).
        distinct.
        order(:tag_name => 'asc').
        pluck(:tag_name)
  end
end