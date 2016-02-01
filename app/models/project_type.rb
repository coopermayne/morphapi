class ProjectType < ActiveRecord::Base
  has_and_belongs_to_many :projects, join_table: "projects_project_types"

  has_many :children, class_name: "ProjectType", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "ProjectType"
end
