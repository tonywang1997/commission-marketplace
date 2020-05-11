class AddHistSizeToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :binary_hist, :binary
    add_column :images, :size, :integer
  end
end
