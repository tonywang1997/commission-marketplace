class Role < ApplicationRecord
  include RolesHelper

  enum category: role_categories
  belongs_to :post
end
