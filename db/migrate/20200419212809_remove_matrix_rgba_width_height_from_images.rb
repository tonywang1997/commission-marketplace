class RemoveMatrixRgbaWidthHeightFromImages < ActiveRecord::Migration[6.0]
  def change

    remove_column :images, :matrix, :string

    remove_column :images, :rgba, :binary

    remove_column :images, :width, :integer

    remove_column :images, :height, :integer
  end
end
