class RemoveUploadIdFromSlide < ActiveRecord::Migration
  def change
    remove_column :slides, :upload_id, :integer
  end
end
