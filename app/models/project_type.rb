# == Schema Information
#
# Table name: project_types
#
#  id         :integer          not null, primary key
#  title      :string
#  rank       :integer
#  ancestry   :string
#  section_id :integer
#

class ProjectType < ActiveRecord::Base
  before_save :set_defaults

  has_and_belongs_to_many :projects, join_table: "projects_project_types"
  belongs_to :section
  has_ancestry

  private
  def set_defaults
    self.rank ||= 999
  end

end
