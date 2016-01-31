class AddPrimaryImageToProject < ActiveRecord::Migration
  def change
    add_column :projects, :primary_id, :integer
  end
end
