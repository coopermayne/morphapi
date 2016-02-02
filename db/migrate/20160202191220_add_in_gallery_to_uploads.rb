class AddInGalleryToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :in_gallery, :boolean
  end
end
