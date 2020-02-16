class AddIndexToUsersEmailAddress < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email_address, unique: true
  end
end
