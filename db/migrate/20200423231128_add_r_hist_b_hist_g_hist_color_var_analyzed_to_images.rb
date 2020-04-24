class AddRHistBHistGHistColorVarAnalyzedToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :r_hist, :binary
    add_column :images, :b_hist, :binary
    add_column :images, :g_hist, :binary
    add_column :images, :color_var, :binary
    add_column :images, :analyzed, :boolean, null: false, default: false
  end
end
