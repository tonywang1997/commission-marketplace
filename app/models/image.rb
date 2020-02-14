class Image < ApplicationRecord
  has_many :artists, through: :has_image
end
