class RemoveTagIdFromTags < ActiveRecord::Migration[6.0]
  def change

    remove_column :tags, :tag_id, :integer
  end
end
