class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.integer :tag_id
      t.text :tag_name

      t.timestamps
    end
  end
end
