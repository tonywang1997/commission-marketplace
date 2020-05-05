class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :has_images
  has_many :has_tags
  has_many :images, through: :has_images
  has_many :tags, through: :has_tags
  
  scope :tagged, -> (tags) { joins(:tags).where("tags.tag_name IN (?)", tags).group("portfolios.id").having('count(*) = ?', tags.count) }
  # use nested form to dynamically add/remove tags
  # https://guides.rubyonrails.org/form_helpers.html#configuring-the-model
  accepts_nested_attributes_for :tags, allow_destroy: true

  # do not allow dangling portfolios
  validates :user_id, 
    presence: true



  def files
    attached_files = []
    self.images.each do |img|
      attached_files << img.file
    end
    attached_files
  end
end
