class AddLinkToBibliographyItems < ActiveRecord::Migration
  def change
    add_column :bibliography_items, :link, :string
  end
end
