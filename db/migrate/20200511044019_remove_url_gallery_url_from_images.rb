class RemoveUrlGalleryUrlFromImages < ActiveRecord::Migration[6.0]
  def change

    remove_column :images, :url, :string

    remove_column :images, :gallery_url, :string
  end
end
