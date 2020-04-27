class AddSnameToMessages < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :sname, :string
  end
end
