# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  project_id  :integer
#  position_id :integer
#

class Role < ActiveRecord::Base
  include Clearcache

  belongs_to :person
  belongs_to :project
  belongs_to :position

  validates_presence_of :person, :project, :position
  validates_associated :person, :project, :position

  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :position
end
