class RemoveUserNameFromPosts < ActiveRecord::Migration[6.0]
  def change

    remove_column :posts, :user_name, :string
  end
end
