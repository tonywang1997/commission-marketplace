class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email_address
      t.string :password
      t.string :profile_thumbnail

      t.timestamps
    end
  end
end
