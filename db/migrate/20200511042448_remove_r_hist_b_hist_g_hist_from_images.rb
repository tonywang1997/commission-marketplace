class RemoveRHistBHistGHistFromImages < ActiveRecord::Migration[6.0]
  def change

    remove_column :images, :r_hist, :binary

    remove_column :images, :b_hist, :binary

    remove_column :images, :g_hist, :binary
  end
end
