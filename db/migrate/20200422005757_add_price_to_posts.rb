class AddPriceToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :price, :float
    add_column :posts, :deadline, :date
  end
end
