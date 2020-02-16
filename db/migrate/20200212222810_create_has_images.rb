class CreateHasImages < ActiveRecord::Migration[6.0]
  def change
    create_table :has_images do |t|
      t.integer :portfolio_id
      t.integer :image_id

      t.timestamps
    end
  end
end
