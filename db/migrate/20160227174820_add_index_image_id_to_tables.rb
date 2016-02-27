class AddIndexImageIdToTables < ActiveRecord::Migration
  def change
    add_column :projects, :index_image_id, :integer
    add_column :news_items, :index_image_id, :integer
    add_column :awards, :index_image_id, :integer
    add_column :bibliography_items, :index_image_id, :integer
    add_column :people, :index_image_id, :integer
  end
end
