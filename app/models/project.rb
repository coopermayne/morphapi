class Project < ActiveRecord::Base
  has_many :components
  has_many :roles

  belongs_to :section
  has_and_belongs_to_many :project_types, join_table: "projects_project_types"
  has_and_belongs_to_many :awards
  has_and_belongs_to_many :bibliography_items

  has_many :uploads
end
