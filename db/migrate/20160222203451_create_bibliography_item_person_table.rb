class CreateBibliographyItemPersonTable < ActiveRecord::Migration
  def change
    create_join_table :bibliography_items, :people
  end
end
