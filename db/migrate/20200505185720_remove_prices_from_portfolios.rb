class RemovePricesFromPortfolios < ActiveRecord::Migration[6.0]
  def change
  	remove_column :portfolios, :price_low, :float
  	remove_column :portfolios, :price_high, :float
  end
end