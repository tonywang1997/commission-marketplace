class Post < ApplicationRecord
    validates :content, presence: true
    validates :deadline, presence: true
    validates :title, presence: true
    validates :price, presence: true

    belongs_to :user
    has_many :post_tags
    has_many :tags, through: :post_tags
    has_many :roles

    def fave_exists?(user_id)
    	!!Favorite.find_by(post_id: self.id, user_id: user_id)
    end
end
