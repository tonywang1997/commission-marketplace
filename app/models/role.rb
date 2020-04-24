class Role < ApplicationRecord
  enum category: [ :animator, :artist, :mixer, :vocalist ]
  belongs_to :post
end
