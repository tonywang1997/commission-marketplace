class FavImage < ApplicationRecord
    belongs_to :image
    belongs_to :favorite
end
