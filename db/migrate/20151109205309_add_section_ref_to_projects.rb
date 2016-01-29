class AddSectionRefToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :section, index: true, foreign_key: true
  end
end
