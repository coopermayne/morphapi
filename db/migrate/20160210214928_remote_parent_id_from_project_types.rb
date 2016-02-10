class RemoteParentIdFromProjectTypes < ActiveRecord::Migration
  def change
    remove_column :project_types, :parent_id, :integer
  end
end
