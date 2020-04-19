class AddRgbaToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :rgba, :binary
  end
end
