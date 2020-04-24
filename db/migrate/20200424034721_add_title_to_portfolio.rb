class AddTitleToPortfolio < ActiveRecord::Migration[6.0]
  def change
  	add_column :portfolios, :title, :text
  end
end
