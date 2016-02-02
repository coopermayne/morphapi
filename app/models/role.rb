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
  belongs_to :person
  belongs_to :project
  belongs_to :position
end
