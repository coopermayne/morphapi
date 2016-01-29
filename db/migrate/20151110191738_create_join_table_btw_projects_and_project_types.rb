class CreateJoinTableBtwProjectsAndProjectTypes < ActiveRecord::Migration
  def change
    create_table :projects_project_types, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :project_type, index: true
    end
  end
end
