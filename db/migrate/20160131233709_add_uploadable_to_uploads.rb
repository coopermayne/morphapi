class AddUploadableToUploads < ActiveRecord::Migration
  def change
    add_reference :uploads, :uploadable, polymorphic: true, index: true
  end
end
