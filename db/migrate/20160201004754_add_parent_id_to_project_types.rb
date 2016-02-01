class AddParentIdToProjectTypes < ActiveRecord::Migration
  def change
    add_reference :project_types, :parent, index: true
  end
end
