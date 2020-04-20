class Image < ApplicationRecord
  has_many :has_images
  has_many :portfolios, through: :has_images
  has_one_attached :file

  def self.tagged(tags)
    if tags.empty?
      return all
    end
    # select(:id).joins(:portfolios => :tags).where("tags.tag_name IN (?)", tags).distinct.group(:id).having('count(*) = ?', tags.count)
    from(Image.joins(:portfolios => :tags).
      where("tags.tag_name IN (?)", tags).
      select('"tags"."tag_name"').
      distinct, :images).
    group(:id, :price, :date).
    having('count(*) = ?', tags.count)
  end

  def self.in_price_range(price_range)
    if price_range.empty?
      return all
    end
    where('price > ? and price < ?', price_range[0], price_range[1])
  end

  def self.tags(*image_ids)
    tag_hash = {}
    if image_ids.any?
      Tag.joins(:portfolios => :images).
          where('images.id IN (?)', image_ids).
          distinct.
          order(:tag_name => 'asc').
          pluck(:tag_name, 'images.id').
          each do |tag_name, image_id|
            tag_hash[image_id] ||= []
            tag_hash[image_id].push(tag_name)
          end
    else
      Tag.joins(:portfolios => :images).
          distinct.
          order(:tag_name => 'asc').
          pluck(:tag_name, 'images.id').
          each do |tag_name, image_id|
            tag_hash[image_id] ||= []
            tag_hash[image_id].push(tag_name)
          end
    end
    tag_hash
  end

  def self.portfolios(*image_ids)
    portfolio_hash = {}
    if image_ids.any?
      HasImage.where('image_id IN (?)', image_ids).
        pluck(:portfolio_id, :image_id).each do |portfolio_id, image_id|
          portfolio_hash[image_id] ||= []
          portfolio_hash[image_id].push(portfolio_id)
        end
    else
      HasImage.pluck(:portfolio_id, :image_id).each do |portfolio_id, image_id|
        portfolio_hash[image_id] ||= []
        portfolio_hash[image_id].push(portfolio_id)
      end
    end
    portfolio_hash
  end

  def tags
    Tag.joins(:portfolios => :images).
        where('images.id = ?', self.id).
        distinct.
        order(:tag_name => 'asc').
        pluck(:tag_name)
  end
end