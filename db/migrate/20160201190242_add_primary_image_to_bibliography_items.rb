class AddPrimaryImageToBibliographyItems < ActiveRecord::Migration
  def change
    add_column :bibliography_items, :primary_id, :integer
  end
end
