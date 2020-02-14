class Artist < ApplicationRecord
  has_many :portfolios
  belongs_to :user
end
