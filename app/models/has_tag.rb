class HasTag < ApplicationRecord
    belongs_to :portfolio
    belongs_to :tag
end
