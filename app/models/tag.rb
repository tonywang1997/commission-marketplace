class Tag < ApplicationRecord
  has_many :has_tags
  has_many :portfolios, through: :has_tags
end
