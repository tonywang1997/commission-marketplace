class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.integer :image_id
      t.string :collection_name

      t.timestamps
    end
  end
end
