class AddAncestryToProjectTypes < ActiveRecord::Migration
  def change
    add_column :project_types, :ancestry, :string
  end
end
