class Post < ApplicationRecord
    belongs_to :user, through: :has_posts
end
