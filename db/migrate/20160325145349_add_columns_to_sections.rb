class AddColumnsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :about, :text
    add_column :sections, :contact, :text
    add_column :sections, :employment, :text
  end
end
