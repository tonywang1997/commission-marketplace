class Post < ApplicationRecord
    validates :content, presence: true
    validates :deadline, presence: true
    validates :title, presence: true
    validates :price, presence: true

    has_many :favorite_posts
    belongs_to :user, through: :favorite_posts
    has_many :post_tags
    has_many :tags, through: :post_tags
    has_many :roles
end
