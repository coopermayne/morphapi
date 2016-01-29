class ProjectType < ActiveRecord::Base
  has_and_belongs_to_many :projects, join_table: "projects_project_types"
end
