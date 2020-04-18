class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :url
      t.string :gallery_url
      t.float :price
      t.date :date
      t.bigint :matrix, :array => true

      t.timestamps
    end
  end
end
