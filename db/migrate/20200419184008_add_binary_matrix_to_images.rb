class AddBinaryMatrixToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :binary_matrix, :binary
  end
end
