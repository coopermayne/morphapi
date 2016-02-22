class AddOldIdColumnToTables < ActiveRecord::Migration
  def change
    add_column :awards, :old_id, :integer
    add_column :bibliography_items, :old_id, :integer
    add_column :component_types, :old_id, :integer
    add_column :components, :old_id, :integer
    add_column :credits, :old_id, :integer
    add_column :file_types, :old_id, :integer
    add_column :news_types, :old_id, :integer
    add_column :people, :old_id, :integer
    add_column :positions, :old_id, :integer
    add_column :project_types, :old_id, :integer
    add_column :projects, :old_id, :integer
    add_column :roles, :old_id, :integer
    add_column :sections, :old_id, :integer
    add_column :uploads, :old_id, :integer
  end
end
