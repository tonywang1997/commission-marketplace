class Role < ApplicationRecord
  @role_categories = [ :animator, :artist, :mixer, :vocalist ]

  enum category: @role_categories
  belongs_to :post
  validates :category, presence: true
  validates :name, presence: true
  validates :description, presence: true

  def self.role_categories
    @role_categories
  end
end
