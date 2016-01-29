class CreateJoinTableBtwAwardsAndProjects < ActiveRecord::Migration
  def change
    create_table :awards_projects, id: false do |t|
      t.belongs_to :award, index: true
      t.belongs_to :project, index: true
    end
  end
end
