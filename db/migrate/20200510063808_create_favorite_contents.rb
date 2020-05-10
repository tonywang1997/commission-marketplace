class CreateFavoriteContents < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_contents do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
