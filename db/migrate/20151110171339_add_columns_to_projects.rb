class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :height, :integer
    add_column :projects, :hit, :integer
    add_column :projects, :city, :string
    add_column :projects, :state, :string
    add_column :projects, :country, :string
  end
end
