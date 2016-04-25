class AddSustainabilityToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sustainability, :text
  end
end
