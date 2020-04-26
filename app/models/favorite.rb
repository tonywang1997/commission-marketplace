class Favorite < ApplicationRecord
    belongs_to :users
    has_many :images, through: :user
end
