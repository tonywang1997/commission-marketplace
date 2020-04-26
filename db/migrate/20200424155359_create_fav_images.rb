class CreateFavImages < ActiveRecord::Migration[6.0]
  def change
    create_table :fav_images do |t|
      t.integer :user_id
      t.integer :image_id

      t.timestamps
    end
  end
end
