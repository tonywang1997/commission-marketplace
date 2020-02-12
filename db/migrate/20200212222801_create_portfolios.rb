class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.integer :artist_id
      t.string :description
      t.float :price_low
      t.float :price_high
      t.date :date_created

      t.timestamps
    end
  end
end
