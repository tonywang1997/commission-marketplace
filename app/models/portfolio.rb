class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :has_images
  has_many :has_tags
  has_many :images, through: :has_images
  has_many :tags, through: :has_tags
  
  scope :tagged, -> (tags) { joins(:tags).where("tags.tag_name IN (?)", tags).group("portfolios.id").having('count(*) = ?', tags.count) }
  has_many_attached :files
  # use nested form to dynamically add/remove tags
  # https://guides.rubyonrails.org/form_helpers.html#configuring-the-model
  accepts_nested_attributes_for :tags, allow_destroy: true

  def seed_files
    attached_files = []
    self.images.select(:id).all.each do |img|
      attached_files.push(img.file)
    end
    attached_files
  end
end
