class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.integer :category
      t.string :name
      t.string :description
      t.integer :post_id

      t.timestamps
    end
  end
end
