class ChangeColumnsInUploads < ActiveRecord::Migration
  def change
    remove_column :uploads, :gallery_id, :integer
  end
end
