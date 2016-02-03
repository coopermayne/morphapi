class AddColumnsToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :image_upload_id, :integer
    add_column :slides, :vida_upload_id, :integer
    add_column :slides, :vidb_upload_id, :integer
    add_column :slides, :gif_upload_id, :integer
  end
end
