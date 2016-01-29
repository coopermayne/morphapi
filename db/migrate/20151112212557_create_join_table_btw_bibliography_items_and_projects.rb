class CreateJoinTableBtwBibliographyItemsAndProjects < ActiveRecord::Migration
  def change
    create_table :bibliography_items_projects, id: false do |t|
      t.belongs_to :bibliography_item, index: true
      t.belongs_to :project, index: true
    end
  end
end
