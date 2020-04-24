class Favorite < ApplicationRecord
    belongs_to :users
    has_many :images, through: :fav_image
end
