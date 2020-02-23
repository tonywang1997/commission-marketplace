class Tag < ApplicationRecord
    has_many :portfolios, through: :has_image
end
