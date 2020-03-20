class CreateHasTags < ActiveRecord::Migration[6.0]
  def change
    create_table :has_tags do |t|
      t.integer :tag_id
      t.integer :portfolio_id

      t.timestamps
    end
  end
end
