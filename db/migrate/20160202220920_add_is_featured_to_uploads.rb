class AddIsFeaturedToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :is_featured, :boolean
  end
end
