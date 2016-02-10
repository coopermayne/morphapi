# == Schema Information
#
# Table name: project_types
#
#  id        :integer          not null, primary key
#  title     :string
#  rank      :integer
#  parent_id :integer
#

class ProjectType < ActiveRecord::Base
  has_and_belongs_to_many :projects, join_table: "projects_project_types"
  has_ancestry
end
