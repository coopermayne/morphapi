class AddProjectRefToRoles < ActiveRecord::Migration
  def change
    add_reference :roles, :project, index: true, foreign_key: true
  end
end
