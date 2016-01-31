class AddGalleryToUploads < ActiveRecord::Migration
  def change
    add_reference :uploads, :gallery, index: true, foreign_key: true
  end
end
